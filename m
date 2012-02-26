Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2BZJGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 04:06:14 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:59698 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab2BZJFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 04:05:35 -0500
X-Auth-Info: 1Ef3JMvGcn75ZyId7W8uGPMcdCq2JPeFguLvkivDjRc=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Kent <raven@themaw.net>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        autofs@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] autofs4: fix compilation without CONFIG_COMPAT
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
	<20120221.221609.218135609185671883.davem@davemloft.net>
	<CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
	<CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
	<CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com>
	<1329889428.2193.45.camel@perseus.themaw.net>
	<1329890027.2193.48.camel@perseus.themaw.net>
	<1329890251.2193.50.camel@perseus.themaw.net>
	<m2vcmuh8dg.fsf_-_@igel.home>
	<CA+55aFxH4_gucG7vpdV5NJPNHoXy5bSGtr0yHqmobvYO6PmjNw@mail.gmail.com>
X-Yow: Vote for ME -- I'm well-tapered, half-cocked, ill-conceived and
 TAX-DEFERRED!
Date: Sun, 26 Feb 2012 10:05:22 +0100
In-Reply-To: <CA+55aFxH4_gucG7vpdV5NJPNHoXy5bSGtr0yHqmobvYO6PmjNw@mail.gmail.com>
	(Linus Torvalds's message of "Sat, 25 Feb 2012 17:31:30 -0800")
Message-ID: <m2399yq819.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> How about this patch instead?

Works as well.

> And if you worry about the size of autofs_sb_info, I think that could
> be made denser by using 'char' or bitfields instead of the various
> ints that hold small values or flags instead.

Since it's local to autofs4 it doesn't really matter that much.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
