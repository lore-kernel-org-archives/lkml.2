Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab2ARDJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 22:09:10 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46940 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab2ARDJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 22:09:09 -0500
X-AuditID: b753bd60-98392ba000007b1b-d1-4f1637d2356f
X-AuditID: b753bd60-98392ba000007b1b-d1-4f1637d2356f
Message-ID: <4F1637B8.8020200@hitachi.com>
Date: Wed, 18 Jan 2012 12:08:40 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ulrich Drepper <drepper@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, pp-manager@sdl.hitachi.co.jp,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: ANDN and Group 17 in x86-opcode-map.txt
References: <CAOPLpQdq5SuVo9=023CYhbFLAX9rONyjmYq7jJkqc5xwctW5eA@mail.gmail.com> <4F15CA4F.9060005@zytor.com>
In-Reply-To: <4F15CA4F.9060005@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/18 4:21), H. Peter Anvin wrote:
> On 01/17/2012 11:14 AM, Ulrich Drepper wrote:
>> The Intel documentation at
>>
>> http://software.intel.com/file/36945
>>
>> shows the ANDN opcode and Group 17 with encoding f2 and f3 encoding
>> respectively.  The current version of x86-opcode-map.txt shows them
>> with f3 and f4.  Unless someone can point to documentation which shows
>> the currently used encoding the following patch be applied.
>>
>> Signed-off-by: Ulrich Drepper <drepper@gmail.com>
>>
> 
> Looks right to me.  Masami, I assume this was just a transcription error?
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>

Oh! right, it must be my typo.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>



-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
