Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab2ENRfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:35:38 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42370 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab2ENRfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:35:36 -0400
Subject: Re: [PATCH RFC] tun: experimental zero copy tx support
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Joe Perches <joe@perches.com>, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian.Campbell@citrix.com, kvm@vger.kernel.org
In-Reply-To: <20120513155206.GA26847@redhat.com>
References: <20120513155206.GA26847@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 May 2012 10:34:50 -0700
Message-ID: <1337016890.3851.20.camel@oc3660625478.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051417-3270-0000-0000-0000065461CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-13 at 18:52 +0300, Michael S. Tsirkin wrote:
> Let vhost-net utilize zero copy tx when the experimental
> zero copy mode is enabled and when used with tun.  This works on
> top of the patchset 'copy aside frags with destructors' that I posted
> previously. This is not using tcp so doesn't have the
> issue with early skb cloning noticed by Ian.
> 
> For those that wish to test this with kvm, I intend to post a patchset
> +
> git tree with just the necessary bits from the destructor patch
> a bit later.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com> 

Hello Mike,

Have you tested this patch? I think the difference between macvtap and
tap is tap forwarding the packet to bridge. The zerocopy is disabled in
this case.

Shirley

