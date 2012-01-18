Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab2ARBCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:02:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44009 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab2ARBCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:02:08 -0500
X-Authority-Analysis: v=2.0 cv=Hf6Wv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=v8bH6B52KJQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=yyCqClCEbQdwXsrae9IA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326848525.17534.66.camel@gandalf.stny.rr.com>
Subject: Re: rt-kernel 3.0.14-rt31: BUG: sleeping function called from
 invalid context
From: Steven Rostedt <rostedt@goodmis.org>
To: Karsten Wiese <fzuuzf@googlemail.com>
Cc: John Kacur <jkacur@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Tue, 17 Jan 2012 20:02:05 -0500
In-Reply-To: <201201180053.52617.fzuuzf@googlemail.com>
References: <CAONaPpFjfGiKKGAzrQNk+MF4k50nRf+wMU8H9491NgHyJrUkyw@mail.gmail.com>
	 <201201180053.52617.fzuuzf@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 00:53 +0100, Karsten Wiese wrote:

> The bug happens because acpi_ev_gpe_detect does
> raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags) before it calls
> acpi_ev_gpe_dispatch.

Correct. I believe there's a fix in the 3.2-rt. I'm working on getting
the updates from it to the stable tree.

-- Steve


