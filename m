Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0K2KRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:17:07 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:12050 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752941Ab0K2KRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:17:05 -0500
X-IronPort-AV: E=Sophos;i="4.59,275,1288566000"; 
   d="scan'208";a="89554485"
Date: Mon, 29 Nov 2010 11:17:02 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Microcai <microcai@fedoraproject.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Lisa Milne <lisa@ltmnet.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: VT console need rewrite
Message-ID: <20101129101702.GS5142@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Microcai <microcai@fedoraproject.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Ted Ts'o <tytso@mit.edu>,
	Lisa Milne <lisa@ltmnet.com>,
	"jonsmirl@gmail.com" <jonsmirl@gmail.com>,
	linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
References: <1290951770.13526.18.camel@cai.gentoo> <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com> <20101129020610.7ea7c79e.lisa@ltmnet.com> <1290961207.13526.31.camel@cai.gentoo> <20101128194624.GP2767@thunk.org> <1290993244.877.3.camel@cai.gentoo> <20101129085829.GM5142@const.bordeaux.inria.fr> <1291023157.9785.2.camel@cai.gentoo> <20101129095823.GQ5142@const.bordeaux.inria.fr> <1291025476.9785.5.camel@cai.gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291025476.9785.5.camel@cai.gentoo>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microcai, le Mon 29 Nov 2010 18:11:16 +0800, a écrit :
> 在 2010-11-29一的 10:58 +0100，Samuel Thibault写道：
> > Simple unicode font (i.e. just go beyond the arbitrary historical-vga
> > 512 glyphs limit for fbcon) might go in.  Double-width is
> > questionable,
> > but it can probably simple enough to be able to get in (there is
> > already
> > some code for it anyway).
> > 
> > But complete unicode support (with arabic ligatures, tibetan
> > combinations, etc.) won't ever be accepted in the kernel as that's far
> > too involved in terms of font rendering.  So the userland way needs to
> > be fixed for these anyway, and then things like chinese will go
> > along...
> > 
> > Samuel 
> 
> YES, my patch just include BMP(mostly CJK), not full UNICODE. IF it can
> be included, then I can do more work to make sure it doesn't break old
> stuff. And it's configurable. users don't have to be forced to use.

It seems you didn't get my point: what is the use of including CJK into
kernel when that won't solve the issue for e.g. arabic, while fixing
fbterm will solve the issue for both arabic and CJK?

Samuel
