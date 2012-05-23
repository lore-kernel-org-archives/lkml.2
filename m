Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab2EWQma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:42:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42083 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab2EWQm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:42:29 -0400
Message-ID: <4FBD1365.4090800@zytor.com>
Date: Wed, 23 May 2012 09:42:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Borislav Petkov <borislav.petkov@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, frank.arnold@amd.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
References: <1337684026-19740-1-git-send-email-bp@amd64.org> <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org> <1337789429.9783.16.camel@laptop> <4FBD0C47.70600@zytor.com> <20120523161932.GN14757@aftab.osrc.amd.com> <CA+55aFx9pgAQEFuNyANpHA6OcBL8LyHwknPUOb4=ysjYd4cnwQ@mail.gmail.com>
In-Reply-To: <CA+55aFx9pgAQEFuNyANpHA6OcBL8LyHwknPUOb4=ysjYd4cnwQ@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 09:40 AM, Linus Torvalds wrote:
> On Wed, May 23, 2012 at 9:19 AM, Borislav Petkov
> <borislav.petkov@amd.com> wrote:
>>
>> Actually we need a BIT() macro that works both
>> on 32- and 64-bit. But that won't be that easy:
> 
> We could use __builtin_choose_expr(), but that *only* works with constants.
> 

And it doesn't work in assembly.  However, I really question the assumption.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

