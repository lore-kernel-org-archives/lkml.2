Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab2GXUOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:14:03 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44412 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab2GXUOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120724201045.GH10534@zod.bos.redhat.com>
References: <20120724182409.GB10534@zod.bos.redhat.com> <20120724183230.GC10534@zod.bos.redhat.com>
 <CA+55aFwFcWoH=QB5tKgVjWcUH3SLCDVNqJY-oXRYy7AWOJfLPA@mail.gmail.com>
 <20120724190302.GE10534@zod.bos.redhat.com> <CA+55aFyn-yMUMdcY8jp65eeoGm3RPzy9p+St35-HGE_xXiVJag@mail.gmail.com>
 <500EF43C.3060200@redhat.com> <CA+55aFwvidWyBK5+U_4r5uibSkk4A-1jbnY-i9BtRgbx=Odo7w@mail.gmail.com>
 <500EF6EF.4080708@redhat.com> <20120724194301.GG10534@zod.bos.redhat.com>
 <CA+55aFygfHj3-PLPj2RZ6pg==7sf3=zKDATW3rVaE9jSOxCd_g@mail.gmail.com> <20120724201045.GH10534@zod.bos.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 13:13:38 -0700
X-Google-Sender-Auth: pxiaR8XWZIeunSXEORIAb2yPZKg
Message-ID: <CA+55aFxG-C9VR0vTJ+dk+uoQp+ONYfYwSeS3zvVzOrD3zdVVrA@mail.gmail.com>
Subject: Re: [PATCH v2] posix_types.h: make __NFDBITS compatible with glibc definition
To: Josh Boyer <jwboyer@redhat.com>
Cc: Jeff Law <law@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 1:10 PM, Josh Boyer <jwboyer@redhat.com> wrote:
>
> Seems fine to me.  In addition to the s/__NFDBITS/BITS_PER_LONG change,
> I'm guessing you'll want the odd FD_ISSET/CLR/ZERO/etc macros in
> linux/time.h killed as well?

Yes. They don't make sense, since the kernel doesn't even *define*
those underscore versions.

> If you don't get to it before me, I'll try whipping something up either
> later this evening or first thing in the morning.

Being the merge window, I already have spent more time than I should
looking at kernel history of just *why* we do that odd thing. I'll go
back to merging Xen stuff and let you play with this..

               Linus
