Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab1DVRcC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 13:32:02 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46715 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab1DVRcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 13:32:00 -0400
Subject: Re: [PATCH V3 0/8] macvtap/vhost TX zero copy support
From: Shirley Ma <mashirle@us.ibm.com>
To: Jon Mason <jdmason@kudzu.us>
Cc: David Miller <davem@davemloft.net>, mst@redhat.com,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTi=ckukmCdOOvQc29vtYgxeiSMGqBw@mail.gmail.com>
References: <1303328216.19336.18.camel@localhost.localdomain>
	 <BANLkTi=ckukmCdOOvQc29vtYgxeiSMGqBw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 10:31:48 -0700
Message-ID: <1303493508.10632.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 10:29 -0400, Jon Mason wrote:
> Why are only these 3 drivers getting support?  As far as I can tell,
> the only requirement is HIGHDMA.  If this is the case, is there really
> a need for an additional flag to support this?  If you can key off of
> HIGHDMA, all devices that support this would get the benefit.

Agreed. So far, I have only verified these three 10Gb NICs we have in
our lab. We can enable all devices which support HIGHDMA.

Thanks
Shirley

