Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab2EPPU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:20:27 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53697 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab2EPPUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:20:25 -0400
Subject: Re: [PATCH RFC] tun: experimental zero copy tx support
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Joe Perches <joe@perches.com>, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian.Campbell@citrix.com, kvm@vger.kernel.org
In-Reply-To: <20120514183929.GB17086@redhat.com>
References: <20120513155206.GA26847@redhat.com>
	 <1337016890.3851.20.camel@oc3660625478.ibm.com>
	 <20120514183929.GB17086@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 May 2012 08:16:55 -0700
Message-ID: <1337181415.10741.18.camel@oc3660625478.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051615-2398-0000-0000-000006B1254E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 21:39 +0300, Michael S. Tsirkin wrote:
> > Hello Mike,
> > 
> > Have you tested this patch? I think the difference between macvtap
> and
> > tap is tap forwarding the packet to bridge. The zerocopy is disabled
> in
> > this case.
> > 
> > Shirley
> 
> Testing in progress, but the patchset I pointed to enables
> zerocopy with bridge. 

Hello Mike,

You meant this patch or another patchset for enabling bridge zerocopy?

I remembered we disabled forward skb zerocopy since the user space
program might hold the buffers too long or forever.

In tap/bridge case, when the tx buffers will be released?

Thanks
Shirley

