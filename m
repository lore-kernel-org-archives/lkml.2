Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200Ab2EPS2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:28:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760076Ab2EPS2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:28:40 -0400
Date: Wed, 16 May 2012 19:51:32 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Joe Perches <joe@perches.com>, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian.Campbell@citrix.com, kvm@vger.kernel.org
Subject: Re: [PATCH RFC] tun: experimental zero copy tx support
Message-ID: <20120516165131.GB10769@redhat.com>
References: <20120513155206.GA26847@redhat.com>
 <1337016890.3851.20.camel@oc3660625478.ibm.com>
 <20120514183929.GB17086@redhat.com>
 <1337181415.10741.18.camel@oc3660625478.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337181415.10741.18.camel@oc3660625478.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 08:16:55AM -0700, Shirley Ma wrote:
> On Mon, 2012-05-14 at 21:39 +0300, Michael S. Tsirkin wrote:
> > > Hello Mike,
> > > 
> > > Have you tested this patch? I think the difference between macvtap
> > and
> > > tap is tap forwarding the packet to bridge. The zerocopy is disabled
> > in
> > > this case.
> > > 
> > > Shirley
> > 
> > Testing in progress, but the patchset I pointed to enables
> > zerocopy with bridge. 
> 
> Hello Mike,
> 
> You meant this patch or another patchset for enabling bridge zerocopy?
> 
> I remembered we disabled forward skb zerocopy since the user space
> program might hold the buffers too long or forever.
> 
> In tap/bridge case, when the tx buffers will be released?
> 
> Thanks
> Shirley

It still fails some tests for me but maybe I'll post the whole
patchset so you can see how it works.
