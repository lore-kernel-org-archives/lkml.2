Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab1LBCCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:02:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33527 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab1LBCCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:02:07 -0500
Message-ID: <4ED83177.7070706@zytor.com>
Date: Thu, 01 Dec 2011 18:01:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
CC: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, mingo@elte.hu,
        suresh.b.siddha@intel.com, eranian@google.com, brgerst@gmail.com,
        robert.richter@amd.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] rework of extended state handling, LWP support
References: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com> <m2ipm2lioy.fsf@firstfloor.org> <20111130173745.GT878@escobedo.osrc.amd.com> <20111130215200.GS24062@one.firstfloor.org> <20111201203605.GB411@escobedo.osrc.amd.com>
In-Reply-To: <20111201203605.GB411@escobedo.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2011 12:36 PM, Hans Rosenfeld wrote:
> 
> So I assume, if you have 10000s of processes on a legacy 32bit system
> that never do any FPU stuff or SSE optimizations, you might indeed waste
> a couple of megabytes. I don't think thats very realistic, but that's
> just my opinion.
> 

A couple of megabytes of *lowmem*...

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

