Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab2FFQWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:22:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40765 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab2FFQWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:22:02 -0400
Message-ID: <4FCF8397.6090505@zytor.com>
Date: Wed, 06 Jun 2012 09:21:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86: Fix wrmsrl() debug wrapper
References: <tip-l4gkfnivwv4yi5mqxjlovymx@git.kernel.org>
In-Reply-To: <tip-l4gkfnivwv4yi5mqxjlovymx@git.kernel.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 09:15 AM, tip-bot for Peter Zijlstra wrote:
> 
> perf/x86: Fix wrmsrl() debug wrapper
> 
> Move the wrmslr() debug wrapper to the common header now that all the
> include games are gone. Also clean it up a bit to avoid multiple
> evaluation of the argument.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-l4gkfnivwv4yi5mqxjlovymx@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

Could you please call this something like trace_wrmsrl() instead of
silently tacking something onto something else that already had meaning?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

