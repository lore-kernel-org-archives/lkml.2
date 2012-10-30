Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964899Ab2J3RNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:13:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29047 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759908Ab2J3RNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:13:15 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=V7vpMoT6iB0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ficjY6ek3-4A:10 a=4zWabA5HZc9f5xMd64YA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351617192.8467.124.camel@gandalf.local.home>
Subject: Re: [PATCH 0/2] irq_work: A couple fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 30 Oct 2012 13:13:12 -0400
In-Reply-To: <CAFTL4hzhTtx_OFeRE+RzsPvMWXr0ncbAjkFhEV-TE_XAFVNbdg@mail.gmail.com>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
	 <1351612350.8467.104.camel@gandalf.local.home>
	 <CAFTL4hzhTtx_OFeRE+RzsPvMWXr0ncbAjkFhEV-TE_XAFVNbdg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 17:25 +0100, Frederic Weisbecker wrote:

> No I was worried about the cpu_relax() in irq_work_sync()

That one is fine too, as this is the purpose of cpu_relax(). Not only to
relax the cpu, but also to tell gcc that the loop needs to be reread.

-- Steve


