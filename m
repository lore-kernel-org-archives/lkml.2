Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab2LMGr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 01:47:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59176 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab2LMGry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 01:47:54 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1355379433.24701.1.camel@wall-e>
References: <1355343572-23074-1-git-send-email-stefani@seibold.net> <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e> <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com> <1355379433.24701.1.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 12 Dec 2012 22:47:31 -0800
To: Stefani Seibold <stefani@seibold.net>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net
Message-ID: <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be a simple matter of sharing pages.  Look perhaps at the x32 vdso for a hint.

Stefani Seibold <stefani@seibold.net> wrote:

>Am Mittwoch, den 12.12.2012, 22:14 -0800 schrieb H. Peter Anvin:
>> This is too late for 3.8 anyway, so there is time to make it work
>correctly before tge 3.9 merge window anyway.  After this merge window
>is over I may pull tjis into a testing branch, but compat support is a
>precondition.
>> 
>> The vdso is only optional if you build in backwards compatibility
>anyway, and software has a right to expect a specific numeric kernel
>version to export a single ABI.
>> 
>
>Any idea or clean solution how i can map the 64 bit vgtod into the 32
>bit address space? Thats the only problem i see.
>
>- Stefani

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
