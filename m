Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083Ab2JYOlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:41:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41900 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933068Ab2JYOlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:41:40 -0400
Message-ID: <50894F8E.9060706@zytor.com>
Date: Thu, 25 Oct 2012 07:41:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Multiple patch authors
References: <1351153972-14019-1-git-send-email-daniel@numascale-asia.com> <20121025110353.GA2623@aftab.osrc.amd.com> <20121025115654.GA27611@gmail.com> <20121025135948.GA308@x1.osrc.amd.com> <50894D84.9030203@zytor.com> <20121025143626.GD308@x1.osrc.amd.com>
In-Reply-To: <20121025143626.GD308@x1.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 07:36 AM, Borislav Petkov wrote:
> On Thu, Oct 25, 2012 at 07:32:36AM -0700, H. Peter Anvin wrote:
>> I have also used:
>>
>> Originally-by:
>>
>> ... for a patch originally written by one person but then
>> extensively reworked to the point of not really being the same work.
>
> Yes, whatever wording we agree upon for the tag, it should be as general
> text as possible so that it fits the majority of multiple authorship
> cases.
>

Not necessarily.  It is actually better to have more specific tags for 
different situations.

There is a reason why tip-bot accepts any tag ending in -by: ...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

