Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570Ab2EWQzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:55:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42244 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab2EWQzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:55:44 -0400
Message-ID: <4FBD167F.7080305@zytor.com>
Date: Wed, 23 May 2012 09:55:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <borislav.petkov@amd.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, frank.arnold@amd.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
References: <1337684026-19740-1-git-send-email-bp@amd64.org> <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org> <1337789429.9783.16.camel@laptop> <4FBD0C47.70600@zytor.com> <20120523161932.GN14757@aftab.osrc.amd.com> <1337790571.9783.28.camel@laptop> <4FBD10D5.6080602@zytor.com> <CA+55aFx383ZXZPrbe+C2Cv=Rr=FsARfs8=OXs-B0hK4Dzb-QLg@mail.gmail.com> <4FBD1493.7000104@zytor.com> <CA+55aFxxMTQVoFQkgViBR-pmcpWrmvtHzV=yT-vfaWJ1eXZf0w@mail.gmail.com>
In-Reply-To: <CA+55aFxxMTQVoFQkgViBR-pmcpWrmvtHzV=yT-vfaWJ1eXZf0w@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 09:54 AM, Linus Torvalds wrote:
> On Wed, May 23, 2012 at 9:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> Any reason we can't just tell people to use BIT() for a native "unsigned
>> long" type (32/64 bits) and BIT_64() if they really want a 64-bit result?
> 
> Well, that's what we're doing now. And it seems to have resulted in
> repeated bugs for architectures where most of the developers run on
> 64-bit machines, but the same code is actually supposed to work on
> 32-bit too (ie x86).
> 

Yes, but I fear that this will result in more subtle bugs which will
therefore be even harder to detect and diagnose.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

