Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965907Ab2JZS3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:29:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14960 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965556Ab2JZS26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:28:58 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=rDHpwsyNOsUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=HXw8KzeH-oIA:10 a=IGanJlqeM-6SkPYQ7gAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351276134.8467.62.camel@gandalf.local.home>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 26 Oct 2012 14:28:54 -0400
In-Reply-To: <508AD291.1010803@gmail.com>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
	  <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
	  <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
	  <1351172849.12171.10.camel@twins>
	  <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>
	  <1351241389.12171.45.camel@twins> <20121026092421.GB628@gmail.com>
	  <1351244130.16863.7.camel@twins> <20121026094207.GA2179@gmail.com>
	  <1351245264.16863.12.camel@twins>
	  <alpine.LFD.2.02.1210261208170.2756@ionos>
	  <1351248244.16863.13.camel@twins> <1351256204.16863.56.camel@twins>
	 <508AD291.1010803@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 11:12 -0700, Juri Lelli wrote:

> - scale down (right by 10) incoming parameters as to do internal
>    math with ~1us resolution (and scale up outgoing params)

Would scaling down by 9 be sufficient? That way the resolution is still
just less than 1us.

-- Steve


