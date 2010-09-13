Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab0IMF4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 01:56:22 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:60286 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab0IMF4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 01:56:21 -0400
Date: Mon, 13 Sep 2010 07:55:49 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, linux-arm-kernel@lists.infradead.org,
        linux kernel <linux-kernel@vger.kernel.org>,
        Jonas =?iso-8859-1?Q?=C5berg?= <jonas.aberg@stericsson.com>
Subject: Re: Regression on UP ARM from commit
 e18d65f0500b95d8724b17d8ea9f1116cf390bbe
Message-ID: <20100913055549.GA14773@jasper.tkos.co.il>
References: <AANLkTimC5Vz7x9+MNJcewijoyw=Nyr6WWP=YR8cxqarH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimC5Vz7x9+MNJcewijoyw=Nyr6WWP=YR8cxqarH@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sun, Sep 12, 2010 at 11:47:39PM +0200, Linus Walleij wrote:
> commit e18d65f0500b95d8724b17d8ea9f1116cf390bbe
> "slub: Remove static kmem_cache_cpu array for boot"

In which tree have you found this commit? I cant find 
e18d65f0500b95d8724b17d8ea9f1116cf390bbe in Linus' (Torvalds) tree up to -rc4.

baruch

> made my ARM 926 UP system hang at boot, if I revert this (have
> to back out a lot of SLUB patches for that) it comes back up. (Same if I
> switch to SLAB.)
> 
> Any hints on how I can get patch around this in a nice way?

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
