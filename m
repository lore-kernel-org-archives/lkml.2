Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1KQWx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:53:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43256 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab1KQWx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:53:27 -0500
Message-ID: <4EC58FF1.109@zytor.com>
Date: Thu, 17 Nov 2011 14:51:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        kbuild@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H.J. Lu" <hjl.tools@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/8] trace: Include <asm/asm-offsets.h> in trace_syscalls.c
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>  <1321569446-20433-6-git-send-email-hpa@linux.intel.com> <1321569737.3533.20.camel@frodo>
In-Reply-To: <1321569737.3533.20.camel@frodo>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 02:42 PM, Steven Rostedt wrote:
> On Thu, 2011-11-17 at 14:37 -0800, H. Peter Anvin wrote:
>> From: "H. Peter Anvin" <hpa@linux.intel.com>
>>
>> Include <asm/asm-offsets.h> into trace_syscalls.c, to allow for
>> NR_syscalls to be automatically generated.
> 
> Did this cause some sort of bug before? What was the issue before this
> patch?
> 

(Of course, there are architectures on which the syscall set isn't a
dense set of numbers in the range [0, NR_syscalls), but that's another
issue entirely.)

	-hpa

