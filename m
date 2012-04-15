Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab2DOK4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 06:56:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:43039 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab2DOK4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 06:56:42 -0400
Message-ID: <1334487366.2528.115.camel@twins>
Subject: Re: [tip:perf/core] perf ui annotate browser: Allow toggling addr
 offset view
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@kernel.org,
        hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, efault@gmx.de, namhyung@gmail.com,
        fweisbec@gmail.com, dsahern@gmail.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Sun, 15 Apr 2012 12:56:06 +0200
In-Reply-To: <20120414010410.GB22114@infradead.org>
References: <tip-4zpgimmz8xv7b5c920el7s45@git.kernel.org>
	 <CA+55aFxnv5Wrix=uREQsEg+tSBE8SFvy0v_76csv3hrnmPYG2A@mail.gmail.com>
	 <CA+55aFwcf2uPCccCVrNdCENZVKyev=ARprNj=5zwp5vxD942pw@mail.gmail.com>
	 <20120414010410.GB22114@infradead.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-13 at 22:04 -0300, Arnaldo Carvalho de Melo wrote:
> Well, if we use Masami's disassembler we would use the actual code as it
> is being used and not the original DSO that was later patched by
> altinstructions. 

Just noting that there's tons of disassemblers available, we need not
wait for Masami's one to complete.
