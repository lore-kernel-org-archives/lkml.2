Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab0JKM3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 08:29:08 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:36494 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab0JKM3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 08:29:06 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: aranym bug, manifests as "ida_remove called for id=13" on recent kernels
References: <20101007174948.GT19804@ZenIV.linux.org.uk>
	<AANLkTin4886D+-yo=zrf2Yj2R5NM9qdRkc3M9cG2rN_F@mail.gmail.com>
	<20101010144952.GF19804@ZenIV.linux.org.uk>
	<AANLkTinuA3AzMoJ82pvCuhmo59DZxL2F1j3xhXUkjj7z@mail.gmail.com>
	<20101010235256.GG19804@ZenIV.linux.org.uk>
	<20101011024103.GH19804@ZenIV.linux.org.uk>
	<19634.55413.877788.492484@pilspetsen.it.uu.se>
X-Yow: I'm not available for comment..
Date: Mon, 11 Oct 2010 14:29:00 +0200
In-Reply-To: <19634.55413.877788.492484@pilspetsen.it.uu.se> (Mikael
	Pettersson's message of "Mon, 11 Oct 2010 11:27:17 +0200")
Message-ID: <m3hbgs3oc3.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson <mikpe@it.uu.se> writes:

> I can confirm that the bug exists in gcc-4.3.4 and gcc-4.4.5,
> but it has been fixed in gcc-4.5.1 which generates:
>
> bar:
>         link.w %fp,#0
>         move.l 8(%fp),-(%sp)
>         jsr foo
>         move.l %d0,%a0
>         unlk %fp
>         rts
>
> I don't yet know the gcc PR number or svn commit # for the fix
> (in case people want a backport).

See http://gcc.gnu.org/PR41302

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
