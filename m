Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab0LCCKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 21:10:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34543 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321Ab0LCCKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 21:10:39 -0500
Message-ID: <4CF85183.5030103@zytor.com>
Date: Thu, 02 Dec 2010 18:10:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Daniel Drake <dsd@laptop.org>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 resend] OLPC: Add XO-1 suspend/resume support
References: <20101118202837.B24899D401B@zog.reactivated.net> <20101202165724.b852b82b.akpm@linux-foundation.org>
In-Reply-To: <20101202165724.b852b82b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2010 04:57 PM, Andrew Morton wrote:
> On Thu, 18 Nov 2010 20:28:37 +0000 (GMT)
> Daniel Drake <dsd@laptop.org> wrote:
> 
>> Add code needed for basic suspend/resume of the XO-1 laptop.
>>
>> Signed-off-by: Daniel Drake <dsd@laptop.org>
>> ---
>>  arch/x86/Kconfig                         |    2 +-
>>  arch/x86/include/asm/olpc.h              |    9 ++-
>>  arch/x86/platform/olpc/Makefile          |    2 +-
>>  arch/x86/platform/olpc/olpc-xo1-wakeup.S |  132 ++++++++++++++++++++++++++++++
>>  arch/x86/platform/olpc/olpc-xo1.c        |   79 ++++++++++++++++++
> 
> i386 allmodconfig:
> 
> make[3]: *** No rule to make target `arch/x86/platform/olpc/olpc-xo1-wakeup.c', 
> 
> I "fixed" that locally by making olpc depend on x86_64.

... which is of course completely busted since olpc is 32 bit.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

