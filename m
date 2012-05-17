Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284Ab2EQSAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 14:00:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54828 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016Ab2EQSAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 14:00:07 -0400
Date: Thu, 17 May 2012 20:00:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, JBottomley@parallels.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH 5/5] MCA: delete all remaining traces of microchannel bus
 support.
Message-ID: <20120517180001.GA17846@gmail.com>
References: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
 <1337272841-25931-6-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337272841-25931-6-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> Hardware with MCA bus is limited to 386 and 486 class machines
> that are now 20+ years old and typically with less than 32MB
> of memory.  A quick search on the internet, and you see that
> even the MCA hobbyist/enthusiast community has lost interest
> in the early 2000 era and never really even moved ahead from
> the 2.4 kernels to the 2.6 series.
> 
> This deletes anything remaining related to CONFIG_MCA from core
> kernel code and from the x86 architecture.  There is no point in
> carrying this any further into the future.
> 
> One complication to watch for is inadvertently scooping up
> stuff relating to machine check, since there is overlap in
> the TLA name space (e.g. arch/x86/boot/mca.c).

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
