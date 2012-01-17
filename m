Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2AQTWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:22:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54004 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755514Ab2AQTWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:22:11 -0500
Message-ID: <4F15CA4F.9060005@zytor.com>
Date: Tue, 17 Jan 2012 11:21:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, pp-manager@sdl.hitachi.co.jp
Subject: Re: ANDN and Group 17 in x86-opcode-map.txt
References: <CAOPLpQdq5SuVo9=023CYhbFLAX9rONyjmYq7jJkqc5xwctW5eA@mail.gmail.com>
In-Reply-To: <CAOPLpQdq5SuVo9=023CYhbFLAX9rONyjmYq7jJkqc5xwctW5eA@mail.gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 11:14 AM, Ulrich Drepper wrote:
> The Intel documentation at
> 
> http://software.intel.com/file/36945
> 
> shows the ANDN opcode and Group 17 with encoding f2 and f3 encoding
> respectively.  The current version of x86-opcode-map.txt shows them
> with f3 and f4.  Unless someone can point to documentation which shows
> the currently used encoding the following patch be applied.
> 
> Signed-off-by: Ulrich Drepper <drepper@gmail.com>
> 

Looks right to me.  Masami, I assume this was just a transcription error?

Acked-by: H. Peter Anvin <hpa@zytor.com>


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

