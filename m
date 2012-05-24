Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab2EXPb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:31:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54415 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab2EXPby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:31:54 -0400
Message-ID: <4FBE5456.5020408@zytor.com>
Date: Thu, 24 May 2012 08:31:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/urgent fixes for v3.5
References: <20120523113432.GA12142@gmail.com> <CA+55aFzCDKK56CRXWXrPPtok84KJY4BbORcT3GfEH8xmOfgP6g@mail.gmail.com> <4FBD1AC8.7020602@zytor.com> <20120523174844.GA3373@gmail.com> <CA+55aFwpja0NxBser2EXjoMRTf0xobcCURqGtqyRXi4daPW0gg@mail.gmail.com>
In-Reply-To: <CA+55aFwpja0NxBser2EXjoMRTf0xobcCURqGtqyRXi4daPW0gg@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 10:57 AM, Linus Torvalds wrote:
> On Wed, May 23, 2012 at 10:48 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> Also, we can rebase the whole branch and get rid of this one and
>> of the merge commit it has.
> 
> I took it, but it was really unnecessary.
> 
> There were printk() patches in the queue and being discussed that
> needed this, but I wouldn't have pulled the end result if they hadn't
> been fixed.
> 

Hi Linus,

Just for clarification - do you want the patch reverted?  My reading of
what you wrote (as well as of the patch) is that it was an unnecessary
(redundant) patch, but Ingo is worried that you are saying it is incorrect.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

