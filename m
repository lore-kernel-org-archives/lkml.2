Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1HEUhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 16:37:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45681 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab1HEUhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 16:37:02 -0400
Message-ID: <4E3C5460.90505@zytor.com>
Date: Fri, 05 Aug 2011 13:36:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: luto@mit.edu, x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, lueckintel@yahoo.com,
        kimwooyoung@gmail.com
Subject: Re: New vsyscall emulation breaks JITs
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com> <20110805202656.GI5782@one.firstfloor.org>
In-Reply-To: <20110805202656.GI5782@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 01:26 PM, Andi Kleen wrote:
>> I have to say I believe that trying to JIT the vdso or vsyscall pages is
>> extremely dubious at best.  They are fundamentally different from normal
>> user space in that the kernel can muck with them any time, without
>> notifying userspace about it.  The other aspect of this is that this is
>> about the legacy vsyscall page, which we're trying to get rid of, partly
>> because of security problems.
> 
> There's clear evidence now you can't: it's used even by new binaries.

time() is not supported by vdso; this is a problem.  Getting rid of it
is a long-term thing.

	-hpa

