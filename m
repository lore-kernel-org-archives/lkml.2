Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab2BIS4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 13:56:46 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56243 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab2BIS4p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 13:56:45 -0500
MIME-Version: 1.0
In-Reply-To: <20120209175114.GA5525@otto.nzcorp.net>
References: <20120208143741.GB28486@otto.nzcorp.net>
	<20120208205628.GA18909@alberich.amd.com>
	<20120209124355.GA20902@otto.nzcorp.net>
	<20120209132825.GB8830@elte.hu>
	<20120209134920.GA25934@otto.nzcorp.net>
	<CAE9FiQUiMBUh9xSKoLj_1ZPXY3wTehB6i1V_mPmx7rs5XqMZTw@mail.gmail.com>
	<20120209175114.GA5525@otto.nzcorp.net>
Date: Thu, 9 Feb 2012 10:56:44 -0800
X-Google-Sender-Auth: RnLh2FpRe0-GMGYpe2vFtkjq2j4
Message-ID: <CAE9FiQUc5Xzvt94sS5HBmQ9E1hyB7GRozP2-xgZk=9y4AUOk9g@mail.gmail.com>
Subject: Re: Memory issues with Opteron 6220
From: Yinghai Lu <yinghai@kernel.org>
To: aowi@novozymes.com, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "JK (Jesper Agerbo Krogh)" <JK@novozymes.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 9:51 AM, Anders Ossowicki <aowi@novozymes.com> wrote:
> On Thu, Feb 09, 2012 at 05:11:04PM +0100, Yinghai Lu wrote:
>> mtrr setting has some problem too.
>>
>> [    3.098277] mtrr: your CPUs had inconsistent fixed MTRR settings
>> [ 3.100001] mtrr: probably your BIOS does not setup all CPUs.
>> [    3.110000] mtrr: corrected configuration.
>>
>> can you boot with "debug ignore_loglevel show_msr=16" ?
>
> Yep, right here:
> http://dev.exherbo.org/~arkanoid/atlas-dmesg-3.2.5-20120209-mtrr.txt
>

Too bad, print_cpu_info() calling for AP get removed by some commit.

now we can not print initial AP register anymore.

Yinghai
