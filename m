Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab0LSTHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 14:07:32 -0500
Received: from smtp.falooley.org ([66.180.170.91]:39261 "EHLO
	smtp.falooley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab0LSTHb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 14:07:31 -0500
Date: Sun, 19 Dec 2010 14:07:20 -0500
From: Jason Lunz <lunz@acm.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Anatolij Gustschin <agust@denx.de>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org
Subject: Re: mtd: fix CONFIG_MTD_COMPLEX_MAPPINGS=n compile
Message-ID: <20101219190720.GA16710@falooley.org>
References: <20071227181524.GA19051@falooley.org>
 <20071228174853.GA4252@uranus.ravnborg.org>
 <20101207072919.GA8511@falooley.org>
 <AANLkTineLxHdcDKZEUGiqVNAauSX_xyQrs49kKaqhiWo@mail.gmail.com>
 <20101207182012.GA10546@falooley.org>
 <1292343878.2538.80.camel@localhost>
 <20101214195124.GA6010@falooley.org>
 <20101216230110.65156c55@wker>
 <20101217042759.GA3148@falooley.org>
 <1292777276.2140.1.camel@koala>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1292777276.2140.1.camel@koala>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You should also drop the changes that
7bc3265a9e9a09d6a9a3cfaaf53ccf3af5271a93 made to drivers/mtd/mtdchar.c -
there's no point changing that when mtdchar is disabled on ARCH=um.

Jason

On Sun, Dec 19, 2010 at 06:47:56PM +0200, Artem Bityutskiy wrote:
> On Thu, 2010-12-16 at 20:27 -0800, Jason Lunz wrote:
> > On Thu, Dec 16, 2010 at 11:01:10PM +0100, Anatolij Gustschin wrote:
> > > This change breaks compiling when CONFIG_MTD_COMPLEX_MAPPINGS is not
> > > defined in the kernel configuration. Please fix!
> > 
> > Sorry, sloppy of me. This reverts all changes to mtd.h while keeping the
> > ability to compile mtd on ARCH=um, with the exception mtdchar.
> 
> Merged with the previous patch, thanks.
> 
> -- 
> Best Regards,
> Artem Bityutskiy (Битюцкий Артём)
> 
> 
