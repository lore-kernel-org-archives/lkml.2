Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab2K1AwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 19:52:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5455 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab2K1Av7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 19:51:59 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=j9wofRDAjcQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=M7XXC4kVkb4A:10 a=n-PutXYuR5WLD03W_GQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354063916.6276.91.camel@gandalf.local.home>
Subject: Re: [PATCH 2/3] cputime: Rename thread_group_times to
 thread_group_cputime_adjusted
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 27 Nov 2012 19:51:56 -0500
In-Reply-To: <CAFTL4hzRmngv+RY0VWfOONCig-Gdvn-2XFVp0fzkc_a83PNO_w@mail.gmail.com>
References: <1353680484-7302-1-git-send-email-fweisbec@gmail.com>
	 <1353680484-7302-3-git-send-email-fweisbec@gmail.com>
	 <1353956163.6276.46.camel@gandalf.local.home>
	 <CAFTL4hxxE8Ggw4Ae-VfgBZ8rtoOMpUQnmSGUado1gxeruwQ9rg@mail.gmail.com>
	 <1353958423.6276.54.camel@gandalf.local.home>
	 <CAFTL4hzRmngv+RY0VWfOONCig-Gdvn-2XFVp0fzkc_a83PNO_w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-28 at 00:51 +0100, Frederic Weisbecker wrote:

> To fix this we apply the above monotonicity fixup.

Thanks for the explanation, although I kind of figured it out
already ;-)

> 
> I can add these explanations on comments in a new patch.

Comments are always good.

-- Steve


