Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2K2VeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:34:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36706 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879Ab2K2VeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:34:04 -0500
Date: Thu, 29 Nov 2012 22:34:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>
Subject: Re: [PATCH 8/8] x86, cleanups: Simplify sync_core() in the case of
 no CPUID
Message-ID: <20121129213402.GJ30789@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Mario Gzuk <mariogzuk@technikz.de>
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com>
 <1354132230-21854-9-git-send-email-hpa@linux.intel.com>
 <20121128204158.GC14635@liondog.tnic>
 <50B7D28A.4000401@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50B7D28A.4000401@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 01:24:26PM -0800, H. Peter Anvin wrote:
> Thinking about it some more, there is another reason to not do
> this, which is that we don't want this particular CPUID to be
> paravirtualized; we're after the synchronizing side effect, not the
> CPUID return value itself.

Ok, you're right, this can be a PVOP call.

> So let's leave it as a primitive; it gets too confusing otherwise.

Ok.

Thanks.

-- 
Regards/Gruss,
    Boris.
