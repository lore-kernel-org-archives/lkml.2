Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab1G3Qbr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 12:31:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:58468 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab1G3Qbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 12:31:42 -0400
Date: Sat, 30 Jul 2011 09:34:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
Message-ID: <20110730093404.6d5098a9@infradead.org>
In-Reply-To: <CA+55aFwMGwVsD1Gexahio2pWd0PpaHAbvFroB3w0=JOQf1zQ_A@mail.gmail.com>
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
	<1311971867-25124-2-git-send-email-hpa@linux.intel.com>
	<1311974171.20898.393.camel@calx>
	<CA+55aFwMGwVsD1Gexahio2pWd0PpaHAbvFroB3w0=JOQf1zQ_A@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011 23:20:40 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> If you don't trust the CPU rng, don't bother with stupid arguments
> about electron microscopes.  

also, if you don't trust the CPU and want an electron microscope, make
sure to also audit the "mov" instruction that you use the cycle after
getting the random number, maybe THAT is booby trapped to muck with the
result ;-)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
