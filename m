Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423301Ab2KNTTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:19:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9384 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab2KNTTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:19:48 -0500
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=l2F7ChNpxMUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=1qqrvxW5imwA:10 a=7gG8LQRT1JzBAUlnawwA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352920786.18025.71.camel@gandalf.local.home>
Subject: Re: [PATCH 3/4] vtime: Consolidate a bit the ctx switch code
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Wed, 14 Nov 2012 14:19:46 -0500
In-Reply-To: <1352910413-10759-4-git-send-email-fweisbec@gmail.com>
References: <1352910413-10759-1-git-send-email-fweisbec@gmail.com>
	 <1352910413-10759-4-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from the subject: vtime: Consolidate a bit the ctx switch code

I read that line several times and it just keeps sounding like some
chant done by the strikers in Greece over the austerity measures...

  "Consolidate a bit! The context switch code!"
  "Consolidate a bit! The context switch code!"
  "Consolidate a bit! The context switch code!"
  "Consolidate a bit! The context switch code!"

I guess because it just sounds Greek to me.


-- Steve


