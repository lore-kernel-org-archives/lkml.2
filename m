Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab1DTU3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:29:54 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42019 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab1DTU3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:29:52 -0400
Subject: Re: [PATCH V3 2/8] Add a new zerocopy device flag
From: Shirley Ma <mashirle@us.ibm.com>
To: Dimitris Michailidis <dm@chelsio.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>, mst@redhat.com,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4DAF40EB.20303@chelsio.com>
References: <1303328216.19336.18.camel@localhost.localdomain>
	 <1303328648.19336.24.camel@localhost.localdomain>
	 <1303328906.2823.24.camel@bwh-desktop>
	 <1303330173.19336.52.camel@localhost.localdomain>
	 <4DAF40EB.20303@chelsio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 13:28:37 -0700
Message-ID: <1303331317.19336.65.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 13:24 -0700, Dimitris Michailidis wrote:
> Bit 30 is also taken in net-next.

How about 31?

Thanks
Shirley

