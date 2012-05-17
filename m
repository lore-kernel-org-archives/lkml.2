Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967773Ab2EQWTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:19:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37917 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967636Ab2EQWTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:19:12 -0400
Message-ID: <4FB57952.2090802@zytor.com>
Date: Thu, 17 May 2012 15:18:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: linux-kernel@vger.kernel.org, JBottomley@parallels.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH 5/5] MCA: delete all remaining traces of microchannel
 bus support.
References: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com> <1337272841-25931-6-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1337272841-25931-6-git-send-email-paul.gortmaker@windriver.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 09:40 AM, Paul Gortmaker wrote:
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

Enthusiastically

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

