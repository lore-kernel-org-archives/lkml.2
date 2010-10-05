Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab0JEJrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 05:47:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42257 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab0JEJrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 05:47:16 -0400
Date: Tue, 5 Oct 2010 11:47:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: hpa@zytor.com
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, torvalds@linux-foundation.org, ryan@innosecc.com,
        tglx@linutronix.de, hpa@linux.intel.com
Subject: Re: [tip:x86/cpu] x86, cpu: Fix X86_FEATURE_NOPL
Message-ID: <20101005094712.GA5626@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
	linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
	mingo@redhat.com, torvalds@linux-foundation.org, ryan@innosecc.com,
	tglx@linutronix.de, hpa@linux.intel.com
References: <20101004073127.GA20305@liondog.tnic>
 <tip-366d4a43b1a7a861c356a0e407c4f03f454d42ea@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-366d4a43b1a7a861c356a0e407c4f03f454d42ea@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: tip-bot for Borislav Petkov <bp@alien8.de>
Date: Mon, Oct 04, 2010 at 08:36:15PM +0000

> Commit-ID:  366d4a43b1a7a861c356a0e407c4f03f454d42ea
> Gitweb:     http://git.kernel.org/tip/366d4a43b1a7a861c356a0e407c4f03f454d42ea
> Author:     Borislav Petkov <bp@alien8.de>
> AuthorDate: Mon, 4 Oct 2010 09:31:27 +0200
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Mon, 4 Oct 2010 11:22:24 -0700
> 
> x86, cpu: Fix X86_FEATURE_NOPL
> 
> ba0593bf553c450a03dbc5f8c1f0ff58b778a0c8 cleared the aforementioned
> cpuid bit only on 32-bit due to various problems with Virtual PC. This
> somehow got lost during the 32- + 64-bit merge so restore the feature
> bit on 64-bit. For that, set it explicitly for non-constant arguments of
> cpu_has(). Update comment for future reference.
> 
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> LKML-Reference: <20101004073127.GA20305@liondog.tnic>
> Cc: Ryan O'Neill <ryan@innosecc.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

tag it for -stable too?

-- 
Regards/Gruss,
Boris.
