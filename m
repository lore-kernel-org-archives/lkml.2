Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab2GXUCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:02:24 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:57877 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab2GXUCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:02:23 -0400
X-Auth-Info: G2gG8lpXJSWxmo1M6Sz8fR3NvPKnnDFkoqPkCN0bOBY=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Jeff Law <law@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] posix_types.h: make __NFDBITS compatible with glibc definition
References: <20120724181209.GA10534@zod.bos.redhat.com>
	<CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
	<20120724182409.GB10534@zod.bos.redhat.com>
	<20120724183230.GC10534@zod.bos.redhat.com>
	<CA+55aFwFcWoH=QB5tKgVjWcUH3SLCDVNqJY-oXRYy7AWOJfLPA@mail.gmail.com>
	<20120724190302.GE10534@zod.bos.redhat.com>
	<CA+55aFyn-yMUMdcY8jp65eeoGm3RPzy9p+St35-HGE_xXiVJag@mail.gmail.com>
	<500EF43C.3060200@redhat.com>
	<CA+55aFwvidWyBK5+U_4r5uibSkk4A-1jbnY-i9BtRgbx=Odo7w@mail.gmail.com>
	<500EF6EF.4080708@redhat.com>
	<20120724194301.GG10534@zod.bos.redhat.com>
X-Yow: I joined scientology at a garage sale!!
Date: Tue, 24 Jul 2012 22:02:17 +0200
In-Reply-To: <20120724194301.GG10534@zod.bos.redhat.com> (Josh Boyer's message
	of "Tue, 24 Jul 2012 15:43:01 -0400")
Message-ID: <m2vchdrkqe.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@redhat.com> writes:

> So glibc has multiple definitions of __FD_ELT.  I originally quoted the
> one from misc/sys/select.h, but the one from the first patch in the
> glibc bugzilla entry is patching misc/bits/select2.h.

See also eb0b6cb.

> I'm going to
> guess that through some kind of implies or header chain, the second is used.

Look at the end of misc/sys/select.h.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
