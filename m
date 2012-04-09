Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab2DIIkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:40:09 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:42516 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751546Ab2DIIkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:40:08 -0400
Date: Mon, 9 Apr 2012 16:39:58 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jason Wang <jasowang@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        Jiri Pirko <jpirko@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH] net: orphan queued skbs if device tx can stall
Message-ID: <20120409083958.GA3951@gondor.apana.org.au>
References: <20120408171323.GA16012@redhat.com> <20120408234951.GA15993@gondor.apana.org.au> <20120409072849.GA12014@redhat.com> <20120409073354.GA3218@gondor.apana.org.au> <20120409073953.GD12014@redhat.com> <20120409082919.GA3471@gondor.apana.org.au> <20120409083402.GA28249@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120409083402.GA28249@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 11:34:02AM +0300, Michael S. Tsirkin wrote:
>
> Puzzled. This patch orphans skbs only if the destination device sets
> IFF_TX_CAN_STALL.  Since the physical NIC doesn't stall forever it never
> sets this flag.
> 
> So it seems that this patch should not affect the configuration
> you describe at all.
> 
> Could you please clarify? What did I miss?

Oops, you're right.  Somehow I was thinking you were patching
virtio-net instead of tun.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
