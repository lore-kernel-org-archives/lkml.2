Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab2DBRSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:18:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59889 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752676Ab2DBRSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:18:16 -0400
Message-ID: <1333387094.20402.2.camel@joe2Laptop>
Subject: Re: [PATCH] [trivial] Fix typo in tty, arm, hotplug, sound and
 others.
From: Joe Perches <joe@perches.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, tiwai@suse.de
Date: Mon, 02 Apr 2012 10:18:14 -0700
In-Reply-To: <1333385748-27692-1-git-send-email-standby24x7@gmail.com>
References: <1333385748-27692-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 01:55 +0900, Masanari Iida wrote:
> Fix multiple typo on printk messages on tty, arm, hotplug
> sound and others.
[]
> diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
[]
> @@ -34,7 +34,7 @@ GAS_STATUS	= $(shell $(srctree)/arch/ia64/scripts/check-gas "$(CC)" "$(OBJDUMP)"
>  KBUILD_CPPFLAGS += $(shell $(srctree)/arch/ia64/scripts/toolchain-flags "$(CC)" "$(OBJDUMP)" "$(READELF)")
>  
>  ifeq ($(GAS_STATUS),buggy)
> -$(error Sorry, you need a newer version of the assember, one that is built from	\
> +$(error Sorry, you need a newer version of the assembler, one that is built from	\
>  	a source-tree that post-dates 18-Dec-2002.  You can find a pre-compiled	\
>  	static binary of such an assembler at:					\

trivia:

The error message has strange whitespace.
This should be on a single line.

I doubt anyone actually gets this error though.

