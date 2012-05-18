Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967064Ab2ERAVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:21:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38790 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965781Ab2ERAVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:21:50 -0400
Message-ID: <4FB5960E.6070205@zytor.com>
Date: Thu, 17 May 2012 17:21:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: "H.J. Lu" <hjl.tools@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [RFC PATCH 00/10] Use __kernel_[u]long_t for x32 user space compatibility
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <201205172019.27462.vapier@gentoo.org>
In-Reply-To: <201205172019.27462.vapier@gentoo.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 05:19 PM, Mike Frysinger wrote:
> On Thursday 17 May 2012 18:13:26 H.J. Lu wrote:
>> From: H.J. Lu <hjl.tools@gmail.com>
>> 
>> This patch set changes a number of places where the kernel
>> headers are exported to user space and currently use explicit
>> "long" or "unsigned long" to use __kernel_[u]long_t in order to
>> be compatible with the x32 user space ABI.  These location are
>> places where x32 uses the x86-64 ABI.
>> 
>> It is quite possible that some, or even all, of these locations
>> should really use dedicated types, but in the meantime this gives
>> the correct results which the current headers do not.
> 
> tangentially related, but what happened to the x86 asm/ptrace.h
> patch i sent that changed all the registers from unsigned long to
> u64 ?  e.g. struct pt_regs { -	unsigned long r15; +	__u64 r15; 
> -mike

Link please?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

