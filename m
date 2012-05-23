Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab2EWQSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:18:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38332 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab2EWQSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:18:31 -0400
Subject: Re: [tip:x86/mce] x86/mce: Fix 32-bit build
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, frank.arnold@amd.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        borislav.petkov@amd.com
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-80f033610fb968e75f5d470233d8d0260d7a72ed@git.kernel.org>
References: <1337684026-19740-2-git-send-email-bp@amd64.org>
	 <tip-80f033610fb968e75f5d470233d8d0260d7a72ed@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 18:18:18 +0200
Message-ID: <1337789898.9783.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 09:08 -0700, tip-bot for Borislav Petkov wrote:
> +                                if (val & BIT_64(62)) {
> +                                       val &= ~BIT_64(62);
> +                                       wrmsrl(msrs[i], val);
>                                  } 

Wouldn't it be much better to name those things, BIT(62), BIT(18) etc.
aren't very descriptive at all.

MCE_MISC_COUNTER_PRESENT is much more descriptive than BIT(62).

