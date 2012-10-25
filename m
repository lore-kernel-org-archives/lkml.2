Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945977Ab2JYOdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:33:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41822 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759796Ab2JYOdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:33:05 -0400
Message-ID: <50894D84.9030203@zytor.com>
Date: Thu, 25 Oct 2012 07:32:36 -0700
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
References: <1351153972-14019-1-git-send-email-daniel@numascale-asia.com> <20121025110353.GA2623@aftab.osrc.amd.com> <20121025115654.GA27611@gmail.com> <20121025135948.GA308@x1.osrc.amd.com>
In-Reply-To: <20121025135948.GA308@x1.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 06:59 AM, Borislav Petkov wrote:
> On Thu, Oct 25, 2012 at 01:56:54PM +0200, Ingo Molnar wrote:
>> No, SOBs are to document patch forwarding. Co-authorship can be
>> expressed a number of ways, such as:
>>
>> Based-on-patch-from: Borislav Petkov <bp@alien8.de>
>>
>> and/or by adding you as a copyright holder to one of the files.
>
> Ok, let's hold this down in writing for future reference and in case I
> forget (which will happen, most probably :-)).
>

I have also used:

Originally-by:

... for a patch originally written by one person but then extensively 
reworked to the point of not really being the same work.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

