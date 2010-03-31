Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab0CaHFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 03:05:52 -0400
Received: from isilmar.linta.de ([213.133.102.198]:40211 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755801Ab0CaHFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 03:05:50 -0400
Date: Wed, 31 Mar 2010 09:05:48 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Alexander Kurz <akurz@blala.de>
Cc: "David S. Miller" <davem@davemloft.net>,
       Ken Kawasaki <ken_kawasaki@spring.nifty.jp>,
       Magnus Damm <damm@opensource.se>, Ben Hutchings <ben@decadent.org.uk>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/pcmcia 3com: replacements of printk() with dev_info() and friends (fwd)
Message-ID: <20100331070548.GA16448@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Alexander Kurz <akurz@blala.de>,
	"David S. Miller" <davem@davemloft.net>,
	Ken Kawasaki <ken_kawasaki@spring.nifty.jp>,
	Magnus Damm <damm@opensource.se>,
	Ben Hutchings <ben@decadent.org.uk>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <alpine.DEB.1.10.1003302019200.11637@blala.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1003302019200.11637@blala.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Mar 30, 2010 at 09:01:41PM +0400, Alexander Kurz wrote:
>  I wrote a patch as suggested by kernel-janitors.
>  It is my first patch, so I highly welcome comments and hints,
>  thanks, Alexander Kurz
> 
> ---------- Forwarded message ----------
> Date: Tue, 30 Mar 2010 18:55:33 +0400 (MSD)
> From: Alexander Kurz <akurz@blala.de>
> To: kernel-janitors@vger.kernel.org
> Subject: [PATCH] net/pcmcia 3com: replacements of printk() with dev_info() 
> and
>     friends
> 
> Hello List,
>  I wrote a patch replacing some printk() with dev_info() and friends
>  for 3com 16-bit PCMCIA cards.
>  As this is my first linux patch, comments are welcome,
>  thanks, Alexander Kurz
> 
> ---------- Forwarded message ----------
> Date: Tue, 30 Mar 2010 18:51:43 +0400
> From: Alexander Kurz <akurz@blala.de>
> To: akurz@blala.de
> 
> >From 84616314b126b730528ca10e704d80eabad96ff8 Mon Sep 17 00:00:00 2001
> From: Alexander Kurz <akurz@kbdbabel.org>
> Date: Tue, 30 Mar 2010 12:08:54 +0200
> Subject: [PATCH] net/pcmcia 3com: replacements of printk() with dev_info() 
> and friends
>  as suggested by kernel-janitors for 3com 16-bit PCMCIA cards


that's two "forwarded message" messages too much :) Other than that, the
only issue I see is that there's a "Signed-off-by"-Line missing. See
Documentation/SubmittingPatches for details.

Best,
	Dominik
