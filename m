Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab0K2KKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:10:01 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59869 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab0K2KKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:10:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=CaAL0Y5TnSSrozZyfCE0+QCpsouKZcT5wG+Xv6FyrSzA1qtqr0fzPF3YDbaNnMQNYc
         szOQzi5pQGO6bL7phg19OsXxxPmx8X4E1T8EqseMT7WMc1QWIh7TcbFr9fPrEYpjUzb8
         nMXh8/J2dxsY20f+E8QZ+LXx/qgsyYYsKyKXM=
Subject: Re: VT console need rewrite
From: Microcai <microcai@fedoraproject.org>
Reply-To: microcai@fedoraproject.org
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Ted Ts'o" <tytso@mit.edu>, Lisa Milne <lisa@ltmnet.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
In-Reply-To: <20101129095823.GQ5142@const.bordeaux.inria.fr>
References: <1290941875.13526.15.camel@cai.gentoo>
	 <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
	 <1290951770.13526.18.camel@cai.gentoo>
	 <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
	 <20101129020610.7ea7c79e.lisa@ltmnet.com>
	 <1290961207.13526.31.camel@cai.gentoo> <20101128194624.GP2767@thunk.org>
	 <1290993244.877.3.camel@cai.gentoo>
	 <20101129085829.GM5142@const.bordeaux.inria.fr>
	 <1291023157.9785.2.camel@cai.gentoo>
	 <20101129095823.GQ5142@const.bordeaux.inria.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: fedoraproject.org
Date: Mon, 29 Nov 2010 18:11:16 +0800
Message-ID: <1291025476.9785.5.camel@cai.gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2010-11-29一的 10:58 +0100，Samuel Thibault写道：
> 
> Simple unicode font (i.e. just go beyond the arbitrary historical-vga
> 512 glyphs limit for fbcon) might go in.  Double-width is
> questionable,
> but it can probably simple enough to be able to get in (there is
> already
> some code for it anyway).
> 
> But complete unicode support (with arabic ligatures, tibetan
> combinations, etc.) won't ever be accepted in the kernel as that's far
> too involved in terms of font rendering.  So the userland way needs to
> be fixed for these anyway, and then things like chinese will go
> along...
> 
> Samuel 

YES, my patch just include BMP(mostly CJK), not full UNICODE. IF it can
be included, then I can do more work to make sure it doesn't break old
stuff. And it's configurable. users don't have to be forced to use.





