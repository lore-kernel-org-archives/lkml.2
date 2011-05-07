Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab1EGPSX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 11:18:23 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:45493 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab1EGPSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 11:18:22 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ppc: Fix compiler warning in ptrace.c [-Wno-array-bounds]
References: <1304777491-7947-1-git-send-email-psomas@cslab.ece.ntua.gr>
	<1304777491-7947-2-git-send-email-psomas@cslab.ece.ntua.gr>
X-Yow: Where's the Coke machine?  Tell me a joke!!
Date: Sat, 07 May 2011 17:18:19 +0200
In-Reply-To: <1304777491-7947-2-git-send-email-psomas@cslab.ece.ntua.gr>
	(Stratos Psomadakis's message of "Sat, 7 May 2011 17:11:30 +0300")
Message-ID: <m2oc3eh744.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stratos Psomadakis <psomas@cslab.ece.ntua.gr> writes:

> +CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"' -Wno-array-bounds

You need to check first whether the option is valid.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
