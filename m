Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab0FNPLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:11:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:40634 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755186Ab0FNPLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:11:32 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18/d30ItFM/y07cNGelrgPDV6KFDtwREmF8fWgIiO
	sxYotE6+rtJow0
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] x86, hweight: Fix UML boot crash
Date: Mon, 14 Jun 2010 17:11:26 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34; KDE/4.4.4; i686; ; )
Cc: Borislav Petkov <bp@amd64.org>, Borislav Petkov <bp@alien8.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201005271944.09541.toralf.foerster@gmx.de> <201006141544.59500.toralf.foerster@gmx.de> <AANLkTik7aQPVl2OsOIhAtMzRHDNw6jkZYzcRNtfi7QSh@mail.gmail.com>
In-Reply-To: <AANLkTik7aQPVl2OsOIhAtMzRHDNw6jkZYzcRNtfi7QSh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201006141711.26975.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Geert Uytterhoeven wrote at 16:39:00
> I assume you did a `make clean' in between?
...
> BTW, I'm also using ccache. Always. Ever. All my (cross)compilers are
Well, I'm unsure - might be I made that mistake, especially b/c I use ccache 
too since years and didn't experienced any fault so far.

-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

