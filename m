Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab2HFK1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:27:13 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:56213 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2HFK1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:27:10 -0400
X-Auth-Info: bnLw79oKnzzvLk3Quy0Qk5zNSAp5ZB0AymTVV76BtkQ=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Len Brown <lenb@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Vasilyev <pavel@pavlinux.ru>
Subject: Re: [PATCH] ACPI: replace strlen("string") with sizeof("string") -1
References: <Pine.LNX.4.44L0.1206301023540.29029-100000@netrider.rowland.org>
	<5011F15A.3060007@kernel.org>
X-Yow: You must be a CUB SCOUT!!  Have you made your MONEY-DROP today??
Date: Mon, 06 Aug 2012 12:26:58 +0200
In-Reply-To: <5011F15A.3060007@kernel.org> (Len Brown's message of "Thu, 26
	Jul 2012 21:39:38 -0400")
Message-ID: <m2wr1cz571.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:

> ...both give the number of chars in the string
> without the '\0', as strncmp() wants,
> but sizeof() is compile-time.

Does this actually change anything?  The compiler is able to expand
strlen at compile time if the argument is a constant, provided that that
builtin strlen isn't disabled.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
