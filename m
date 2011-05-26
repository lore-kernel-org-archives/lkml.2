Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab1EZUbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:31:51 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:51709 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab1EZUbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:31:50 -0400
Subject: Re: [PATCH V6 0/4 net-next] macvtap/vhost TX zero-copy support
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110526202836.GA1951@redhat.com>
References: <1306440020.5180.47.camel@localhost.localdomain>
	 <20110526202836.GA1951@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 13:31:25 -0700
Message-ID: <1306441885.5180.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 23:28 +0300, Michael S. Tsirkin wrote:
> On Thu, May 26, 2011 at 01:00:20PM -0700, Shirley Ma wrote:
> > 3. Add sleep in vhost shutting down instead of busy-wait for
> outstanding
> >    DMAs.
> 
> I still think this is not much better. We need to use a
> completion structure and wait on it instead.
> If this gets blocked thinkably a tx watchdog can fire and save us
> from blocking forver :) 

Ok, I can add a completion structure here.

Thanks
Shirley

