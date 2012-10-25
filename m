Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277Ab2JYAI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:08:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27414 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab2JYAIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:08:24 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=rDHpwsyNOsUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=HXw8KzeH-oIA:10 a=CozT_dG12Q1qh1VjV5wA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351123698.8467.28.camel@gandalf.local.home>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 24 Oct 2012 20:08:18 -0400
In-Reply-To: <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
	 <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
	 <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 16:18 -0700, Linus Torvalds wrote:

>   #ifdef __SIZEOF_INT128__
>     #include <linux/native-128bit.h>
>   #elif CONFIG_64BIT
>     #include <linux/generic64bit-128bit.h>
>   #else
>     #include <linux/generic64bit-128bit.h>
>   #endif
> 

I'm assuming you meant the last include to be:

  #include <linux/generic32bit-128bit.h>

Cut and paste should be a federal crime.

-- Steve


