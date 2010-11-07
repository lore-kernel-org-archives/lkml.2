Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab0KGPb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 10:31:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42130 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753233Ab0KGPb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 10:31:28 -0500
Date: Sun, 7 Nov 2010 15:27:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, Marcus Meissner <meissner@suse.de>,
        security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to
 reduce ease of attacking
Message-ID: <20101107152720.7e2c472e@lxorguk.ukuu.org.uk>
In-Reply-To: <20101107123232.GB6512@elte.hu>
References: <20101104215157.GA25128@elte.hu>
	<20101104223526.GC31236@1wt.eu>
	<20101107085016.GA23843@elte.hu>
	<20101107094932.GT4627@1wt.eu>
	<20101107112709.GA2634@elte.hu>
	<20101107114156.GV4627@1wt.eu>
	<20101107114756.GB3759@elte.hu>
	<20101107115626.GX4627@1wt.eu>
	<20101107121235.GA6221@elte.hu>
	<20101107122227.GY4627@1wt.eu>
	<20101107123232.GB6512@elte.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This makes it _unsafe_ (for many types of attackers) to run an exploit locally.

They don't care.

Firstly it 's trivial to identify the true kernel version from all sorts
of other methods and secondly almost all exploiting is done by robots
running from box to box and which are completely disposable.

They simply *don't* care and if they do the rpm -q, tcp finger prints and
a few other tricks such as clock timing a couple of syscalls will answer
the question reliably anyway.

