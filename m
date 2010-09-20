Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab0ITPMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:12:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38689 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543Ab0ITPMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:12:05 -0400
Message-ID: <4C9779AF.8080303@zytor.com>
Date: Mon, 20 Sep 2010 08:11:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 2/2] x86, CPUID: Correct operator precedence when generating
 mask
References: <20100920140621.GA4920@aftab>
In-Reply-To: <20100920140621.GA4920@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2010 07:06 AM, Borislav Petkov wrote:
> NEED_<cpufeature> masks used in the CPU feature testing macros are
> cutoff at the last 5 bits to prevent overflow since the cpu feature
> words are 32-bit-wide bitfields. Fix this for the PSE and PGE masks too.
> 
> This wasn't a real problem since the PSE and PGE bits are nicely < 31.
> 
> Cc: stable@kernel.org
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Since this is a non-manifest bug there really doesn't seem to be any
reason to bother stable with it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

