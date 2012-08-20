Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2HTUTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:19:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:26425 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060Ab2HTUTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:19:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,798,1336374000"; 
   d="scan'208";a="188915261"
From: Andi Kleen <andi@firstfloor.org>
To: Jim Meyering <jim@meyering.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: a few strncpy-related patches
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
Date: Mon, 20 Aug 2012 13:18:42 -0700
In-Reply-To: <1345481724-30108-1-git-send-email-jim@meyering.net> (Jim
	Meyering's message of "Mon, 20 Aug 2012 18:55:19 +0200")
Message-ID: <m24nnx8ggt.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Meyering <jim@meyering.net> writes:

> I've seen a few too many cases of strncpy misuse.
> Looking through linux sources, I spotted/fixed these:
>
> [PATCH] ACPI: remove unwarranted use of strncpy
> [PATCH] fs/9p: avoid debug OOPS when reading a long symlink
> [PATCH] kmemleak: avoid buffer overrun: NUL-terminate strncpy-copied
> [PATCH] bfa: avoid buffer overrun for 12-byte model name
> [PATCH] cifs: remove misleading strncpy: each name has length < 16

Better to convert tham all to strlcpy? 

The kernel has it.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
