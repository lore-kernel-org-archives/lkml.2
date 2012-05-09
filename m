Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570Ab2EIR0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:26:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38394 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab2EIR0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:26:16 -0400
Date: Wed, 9 May 2012 19:26:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Igor Mammedov <imammedo@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
Message-ID: <20120509172611.GC8135@gmail.com>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
 <4FAA452A.1070909@gmail.com>
 <4FAA588B.5010404@redhat.com>
 <1336564330.2527.23.camel@twins>
 <4FAA5BFB.40309@redhat.com>
 <1336566096.2527.30.camel@twins>
 <1336566644.2527.33.camel@twins>
 <1336570043.2527.38.camel@twins>
 <CA+55aFyjGZ=PLOBfyFub4kS3r2vJ0SFD58rTf21koPodFTSARQ@mail.gmail.com>
 <1336584160.2527.62.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336584160.2527.62.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > A "%.*pb" is the only interface that can work for a "sized" 
> > bitmap (with obviously fixed-length ones being possible with 
> > a "%.32bp" like thing)
> 
> Right, sadly that also generates a warning :/

Why not use what I suggested, %*pb? It also doubles as a width 
field in essence, as bitmap output is fundamentally fixed width.

Thanks,

	Ingo
