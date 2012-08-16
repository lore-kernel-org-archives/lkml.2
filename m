Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab2HPOce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:32:34 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:34364 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964797Ab2HPObl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:31:41 -0400
X-Auth-Info: V1WuPa4s8O4Esd9M17NhViyEL7P6ouTw8M4HxLYhXF0=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Regression: Spurious "^A" in UML output
References: <CAMuHMdVEKpVYn+Yr5rzdOvV5zUWrD12Fas197Mn2oVDC5YgVgw@mail.gmail.com>
	<1345125049.26882.16.camel@joe2Laptop>
X-Yow: On the road, ZIPPY is a pinhead without a purpose, but never
 without a POINT.
Date: Thu, 16 Aug 2012 16:31:37 +0200
In-Reply-To: <1345125049.26882.16.camel@joe2Laptop> (Joe Perches's message of
	"Thu, 16 Aug 2012 06:50:49 -0700")
Message-ID: <m2393mhprq.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> Perhaps it's better to change the um STR macro instead

The STR macro is only used to turn the expansion into a C string to be
parsed by the compiler.  The real problem is that the expansion now
contains spaces, which makes the output ambigous.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
