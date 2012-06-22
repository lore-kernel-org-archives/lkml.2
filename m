Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762162Ab2FVNjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:39:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59907 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932877Ab2FVNjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:39:04 -0400
References: <20120621162807.3c621d46@endymion.delvare> <4FE34BCB.5050305@linux.intel.com> <4FE434C0020000780008B45A@nat28.tlf.novell.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <4FE434C0020000780008B45A@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86, cpufeature: Fix duplicate feature name "dts"
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 22 Jun 2012 06:38:28 -0700
To: Jan Beulich <JBeulich@suse.com>, Jean Delvare <khali@linux-fr.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <14009cd9-2cb2-4471-95d9-db8d0df10fa0@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Definitely!

Jan Beulich <JBeulich@suse.com> wrote:

>>>> On 21.06.12 at 18:28, "H. Peter Anvin" <hpa@linux.intel.com> wrote:
>> Good spotting, but I'm worried this is the wrong fix.
>> 
>> This is a userspace ABI change, and the and we have used "dts" for
>debug
>> store (debug trace store?) for a very long tie, whereas digital
>thermal
>> sensor only has been used since 2010; another *major* question is
>which
>> of these is more likely to be of interest to userspace.
>> 
>> Jan, do you have any feeling on this?
>
>Now that you already figured that there is user space code
>depending on the current (questionable) string, I don't think
>it matters much - I would have preferred to correct the string
>to match the CPUID documentation (albeit I seem to recall
>that early on the bit was indeed named DTS in the doc).
>
>Wouldn't it be helpful if mkcapflags.pl detected duplicates?
>
>Jan

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
