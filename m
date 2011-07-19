Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1GSVGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 17:06:24 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49297 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1GSVGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 17:06:23 -0400
MIME-Version: 1.0
In-Reply-To: <1311109112-12909-1-git-send-email-jason.wessel@windriver.com>
References: <1311109112-12909-1-git-send-email-jason.wessel@windriver.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 19 Jul 2011 17:06:01 -0400
X-Google-Sender-Auth: Wr-2qoI7OYgQD2gvrePryOTXawg
Message-ID: <CAJaTeTr1HxcEX9MT83iDZHmCyE=yGhXYDUB0xBmwAn43F_+4ew@mail.gmail.com>
Subject: Re: [PATCH] sparc,kgdbts: fix compile regression with kgdb test suite
To: Jason Wessel <jason.wessel@windriver.com>
Cc: davem@davemloft.net, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 16:58, Jason Wessel wrote:
> Commit 63ab25ebbc (kgdbts: unify/generalize gdb breakpoint adjustment)
> introduced a compile regression on sparc.
>
> kgdbts.c: In function 'check_and_rewind_pc':
> kgdbts.c:307: error: implicit declaration of function 'instruction_pointer_set'
>
> Simply add the correct macro definition for instruction pointer on the
> Sparc architecture.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
