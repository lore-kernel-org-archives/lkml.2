Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2J2N43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:56:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18024 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab2J2N42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:56:28 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=brdkUPH-HS4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ur7i6xMv9e4A:10 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=t7CeM3EgAAAA:8 a=0lz4je6dIh7B_asKB6gA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=2e6ZYRoF4I4A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351518986.8467.68.camel@gandalf.local.home>
Subject: Re: [RFC PATCH 4/9] irq_work: Let the arch tell us about self-IPI
 support
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Mon, 29 Oct 2012 09:56:26 -0400
In-Reply-To: <1351517296-9173-5-git-send-email-fweisbec@gmail.com>
References: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
	 <1351517296-9173-5-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 14:28 +0100, Frederic Weisbecker wrote:
> This prepares us to make printk working on nohz CPUs
> using irq work.

-ENOTENOUGHINFO

Please state how this prepares printk for nohz CPUS using irq_work.

Thanks,

-- Steve

> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---


