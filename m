Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab1LSQcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:32:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35443 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab1LSQcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:32:06 -0500
Date: Mon, 19 Dec 2011 17:30:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Glauber Costa <glommer@parallels.com>
Subject: Re: linux-next: manual merge of the tip tree with the cputime tree
Message-ID: <20111219163009.GC10017@elte.hu>
References: <20111219154010.c2044c038a6174dd8fb6f477@canb.auug.org.au>
 <20111219080813.GB30432@elte.hu>
 <20111219101134.3c2c0db5@de.ibm.com>
 <20111219103513.GA17928@elte.hu>
 <20111219112547.GA32375@elte.hu>
 <20111219152409.3a2c213e@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219152409.3a2c213e@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> > That way your commits are preserved and the conflicts are 
> > resolved.
> 
> Just did that and pushed out the result on
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git cputime-tip

Hm, this fails spectacularly on 32-bit x86:

/home/mingo/tip/drivers/cpufreq/cpufreq_ondemand.c: In function 'get_cpu_idle_time_jiffy':
/home/mingo/tip/drivers/cpufreq/cpufreq_ondemand.c:137: error: expected ';' before ')' token
/home/mingo/tip/drivers/cpufreq/cpufreq_ondemand.c:137: error: expected statement before ')' token

Thanks,

	Ingo
