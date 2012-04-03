Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab2DCH4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:56:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49575 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2DCH4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:56:07 -0400
MIME-Version: 1.0
In-Reply-To: <4F7A2592.1060102@zytor.com>
References: <20120401160229.4502.2541.stgit@shimauta> <20120402070446.GA12689@gmail.com>
 <4F7A2592.1060102@zytor.com>
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Date: Tue, 3 Apr 2012 16:55:44 +0900
Message-ID: <CADyE4xFEvoXQV_1qZy1O2RNbMsOCebYpnjNauMFVP6jfn9kNVw@mail.gmail.com>
Subject: Re: [RFC PATCH -tip 00/16] in-kernel x86 disassember
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/3 H. Peter Anvin <hpa@zytor.com>:
> On 04/02/2012 12:04 AM, Ingo Molnar wrote:
>> Perf could use
>> a programmatic, librarized disassembler for its assembly
>> annotation code.
>
> BTW, it should be pretty trivial to librarize the disassembler from
> NASM.  Even more so, I think this might have already been done with Yasm.

Technically, yes. There are already many disassemblers. This series
was just started for my interesting of how disassember works and
helps kprobes debugging :)

Oh, and also, I'd like to try reusing x86-opcode-map.txt which is already
in the kernel tree. :)

Thank you,


-- 
Masami Hiramatsu
mailto:masami.hiramatsu@gmail.com
