Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab2DRApd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 20:45:33 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39321 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab2DRApb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 20:45:31 -0400
X-Greylist: delayed 152409 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2012 20:45:31 EDT
X-AuditID: b753bd60-99794ba000007b1b-c5-4f8e0ea8a204
X-AuditID: b753bd60-99794ba000007b1b-c5-4f8e0ea8a204
Message-ID: <4F8E0E31.6030404@hitachi.com>
Date: Wed, 18 Apr 2012 09:43:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [tip:perf/core] perf ui annotate browser: Allow toggling addr
 offset view
References: <tip-4zpgimmz8xv7b5c920el7s45@git.kernel.org>  <CA+55aFxnv5Wrix=uREQsEg+tSBE8SFvy0v_76csv3hrnmPYG2A@mail.gmail.com>  <CA+55aFwcf2uPCccCVrNdCENZVKyev=ARprNj=5zwp5vxD942pw@mail.gmail.com>  <20120414010410.GB22114@infradead.org> <20120414085519.GB28505@gmail.com>  <20120414162851.GD22114@infradead.org> <4F8BBB4D.5090409@hitachi.com>  <CA+55aFy5pfzKfaDCc0jbQ5_+_+MMso_XqRcR-KqkZMwcSXAbPQ@mail.gmail.com> <1334589710.28150.66.camel@twins>
In-Reply-To: <1334589710.28150.66.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/17 0:21), Peter Zijlstra wrote:
> On Mon, 2012-04-16 at 08:02 -0700, Linus Torvalds wrote:
>>
>> It really would be *much* better if you could parse the
>> 'altinstructions' section. You already have a lot of ELF parsing code.
>>
> altinstructions, altinstr_replacement, smp_locks, __jump_table,
> parainstructions, __mcount_loc and maybe a few more.. and that doesn't
> allow for kprobes.
> 
> But yeah, being able to grok some of that would be neat.
> 

I sse. For the kprobes, at least live time, we can see where
kprobes are put via /sys/kernel/debug/kprobes/list.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
