Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab2BIQLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:11:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35229 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab2BIQLG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:11:06 -0500
MIME-Version: 1.0
In-Reply-To: <20120209134920.GA25934@otto.nzcorp.net>
References: <20120208143741.GB28486@otto.nzcorp.net>
	<20120208205628.GA18909@alberich.amd.com>
	<20120209124355.GA20902@otto.nzcorp.net>
	<20120209132825.GB8830@elte.hu>
	<20120209134920.GA25934@otto.nzcorp.net>
Date: Thu, 9 Feb 2012 08:11:04 -0800
X-Google-Sender-Auth: 3v7hO6TM0HGG6R9O9y1PRaFvwyI
Message-ID: <CAE9FiQUiMBUh9xSKoLj_1ZPXY3wTehB6i1V_mPmx7rs5XqMZTw@mail.gmail.com>
Subject: Re: Memory issues with Opteron 6220
From: Yinghai Lu <yinghai@kernel.org>
To: aowi@novozymes.com, Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "JK (Jesper Agerbo Krogh)" <JK@novozymes.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 5:49 AM, Anders Ossowicki <aowi@novozymes.com> wrote:
> On Thu, Feb 09, 2012 at 02:28:25PM +0100, Ingo Molnar wrote:
>> Your bootlog says:
>>
>> [    0.330000] Performance Events: Broken BIOS detected, complain to your hardware vendor.
>> [    0.330000] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 1430076)
>>
>> Do you get that message if DBPM is enabled?
>
> It's there with System DBPM, OS DBPM and with power management disabled (i.e.
> set to maximum performance).

mtrr setting has some problem too.

[    3.098277] mtrr: your CPUs had inconsistent fixed MTRR settings
[    3.100001] mtrr: probably your BIOS does not setup all CPUs.
[    3.110000] mtrr: corrected configuration.

can you boot with "debug ignore_loglevel show_msr=16" ?

Yinghai
