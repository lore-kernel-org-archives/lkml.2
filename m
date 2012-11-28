Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab2K1Uad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:30:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59361 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab2K1Uac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:30:32 -0500
Date: Wed, 28 Nov 2012 21:30:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>
Subject: Re: [PATCH 3/8] x86, 386 removal: Remove CONFIG_XADD
Message-ID: <20121128203028.GB14635@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Mario Gzuk <mariogzuk@technikz.de>
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com>
 <1354132230-21854-4-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1354132230-21854-4-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 11:50:25AM -0800, H. Peter Anvin wrote:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> All 486+ CPUs support CMPXCHG, so remove the fallback 386 support
> code.

This commit message should say something about XADD and not about
CMPXCHG, right?

-- 
Regards/Gruss,
    Boris.
