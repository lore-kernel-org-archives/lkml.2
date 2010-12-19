Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab0LSQyP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 11:54:15 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:36224 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab0LSQyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 11:54:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DtEC4zB7DsVwZ82u6y/HFgbuxVk6z5/JVgBJ7lfGVsYolbXeK2npf2Q/yWuaBUOmTC
         hhYsEytGNEh09Vl3EN+YMH7bMj0KNa7cMo0y1mRXncIK3MupCDYzAM/DwNGr2C/qKNbz
         MSqB+qWMKiZ/O15Ox3Ybd6NMQIj4Uue1QFXa0=
Subject: Re: mtd: fix CONFIG_MTD_COMPLEX_MAPPINGS=n compile
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jason Lunz <lunz@acm.org>
Cc: Anatolij Gustschin <agust@denx.de>, atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, Jeff Dike <jdike@addtoit.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        Rob Landley <rob@landley.net>, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20101217042759.GA3148@falooley.org>
References: <20071024011712.GA3762@falooley.org>
	 <1193208689.26096.48.camel@pmac.infradead.org>
	 <20071227181524.GA19051@falooley.org>
	 <20071228174853.GA4252@uranus.ravnborg.org>
	 <20101207072919.GA8511@falooley.org>
	 <AANLkTineLxHdcDKZEUGiqVNAauSX_xyQrs49kKaqhiWo@mail.gmail.com>
	 <20101207182012.GA10546@falooley.org> <1292343878.2538.80.camel@localhost>
	 <20101214195124.GA6010@falooley.org> <20101216230110.65156c55@wker>
	 <20101217042759.GA3148@falooley.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 18:47:56 +0200
Message-ID: <1292777276.2140.1.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 20:27 -0800, Jason Lunz wrote:
> On Thu, Dec 16, 2010 at 11:01:10PM +0100, Anatolij Gustschin wrote:
> > This change breaks compiling when CONFIG_MTD_COMPLEX_MAPPINGS is not
> > defined in the kernel configuration. Please fix!
> 
> Sorry, sloppy of me. This reverts all changes to mtd.h while keeping the
> ability to compile mtd on ARCH=um, with the exception mtdchar.

Merged with the previous patch, thanks.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

