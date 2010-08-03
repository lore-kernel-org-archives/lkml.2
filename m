Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab0HCQBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:01:33 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:1111 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab0HCQBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:01:31 -0400
Date: Tue, 3 Aug 2010 13:00:13 -0300
From: Leandro Lucarella <luca@llucax.com.ar>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Kailang Yang <kailang@realtek.com>, Daniel T Chen <crimsun@ubuntu.com>,
        alsa-devel@alsa-project.org
Subject: Re: Regression 2.6.35: Intel N10/ICH 7 Family HDA (Realtek ALC662
 rev1) beep broken
Message-ID: <20100803160013.GF3508@llucax.com.ar>
References: <20100803040054.GX3508@llucax.com.ar>
 <s5h39uw6ymf.wl%tiwai@suse.de>
 <20100803134409.GA3508@llucax.com.ar>
 <s5hhbjblscn.wl%tiwai@suse.de>
 <20100803144810.GD3508@llucax.com.ar>
 <s5h7hk7lnxg.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5h7hk7lnxg.wl%tiwai@suse.de>
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai, el  3 de agosto a las 17:24 me escribiste:
> > > I can add such a trivial patch manually, of course.  But I'd need
> > > to know which machine you have (vendor/model name, etc).
> > 
> > Is a desktop box.
> > CPU Intel(R) Core(TM)2 Quad CPU    Q8400  @ 2.66GHz
> > Motherboard Intel Corporation DG41RQ
> 
> OK, it's fine, I just wanted to be sure that it's no other brand.
> The fix is now applied to sound tree, and will be included in the next
> pull request, then will reach to stable tree.

Thank you.

-- 
Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
----------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------
La esperanza es una amiga que nos presta la ilusión.
