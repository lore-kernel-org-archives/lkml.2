Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831Ab1ETUVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 16:21:51 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:57735 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934278Ab1ETUVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 16:21:51 -0400
Date: Fri, 20 May 2011 22:21:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Richard Henderson <rth@twiddle.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>,
        "JamesE.J.Bottomley" <jejb@parisc-linux.org>
Subject: Re: [RFC][PATCH] extable: Make sure all archs define _sdata
Message-ID: <20110520202147.GA24378@merkur.ravnborg.org>
References: <1305855298.1465.19.camel@gandalf.stny.rr.com> <4DD67A90.7010908@twiddle.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD67A90.7010908@twiddle.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Acked-by: Richard Henderson <rth@twiddle.net>
> 
> Although I suppose if we're supposedly standardizing on _sdata,
> the two uses of _data in arch/alpha/mm/ could be transitioned.

>From include/asm-generic/vmlinux.lds.h:

 *
 *      _sdata = .;
 *      RO_DATA_SECTION(PAGE_SIZE)
 *      RW_DATA_SECTION(...)
 *      _edata = .;
 *

So yes - we do standardize on _sdata.
Other symbols for the same ought to be replaced...

	Sam
