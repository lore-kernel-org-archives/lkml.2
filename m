Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2DPPWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:22:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59983 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab2DPPWU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:22:20 -0400
Message-ID: <1334589710.28150.66.camel@twins>
Subject: Re: [tip:perf/core] perf ui annotate browser: Allow toggling addr
 offset view
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Mon, 16 Apr 2012 17:21:50 +0200
In-Reply-To: <CA+55aFy5pfzKfaDCc0jbQ5_+_+MMso_XqRcR-KqkZMwcSXAbPQ@mail.gmail.com>
References: <tip-4zpgimmz8xv7b5c920el7s45@git.kernel.org>
	 <CA+55aFxnv5Wrix=uREQsEg+tSBE8SFvy0v_76csv3hrnmPYG2A@mail.gmail.com>
	 <CA+55aFwcf2uPCccCVrNdCENZVKyev=ARprNj=5zwp5vxD942pw@mail.gmail.com>
	 <20120414010410.GB22114@infradead.org> <20120414085519.GB28505@gmail.com>
	 <20120414162851.GD22114@infradead.org> <4F8BBB4D.5090409@hitachi.com>
	 <CA+55aFy5pfzKfaDCc0jbQ5_+_+MMso_XqRcR-KqkZMwcSXAbPQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 08:02 -0700, Linus Torvalds wrote:
> 
> It really would be *much* better if you could parse the
> 'altinstructions' section. You already have a lot of ELF parsing code.
> 
altinstructions, altinstr_replacement, smp_locks, __jump_table,
parainstructions, __mcount_loc and maybe a few more.. and that doesn't
allow for kprobes.

But yeah, being able to grok some of that would be neat.
