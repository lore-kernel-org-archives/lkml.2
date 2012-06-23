Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2FWK7h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:59:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:37385 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab2FWK7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:59:36 -0400
Date: Sat, 23 Jun 2012 12:59:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        leroy christophe <christophe.leroy@c-s.fr>
Subject: Re: [PATCH RT 2/3] Oops during Init IRQ
In-Reply-To: <20120623030639.113614886@goodmis.org>
Message-ID: <alpine.LFD.2.02.1206231257560.2853@ionos>
References: <20120623030548.500374594@goodmis.org> <20120623030639.113614886@goodmis.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012, Steven Rostedt wrote:

You asked for a changelog. Here you go:

Subject: powerpc: Mark low level irq handlers NO_THREAD

These low level handlers cannot be threaded. Mark them NO_THREAD

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
