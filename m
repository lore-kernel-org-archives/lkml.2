Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254Ab2CBPP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:15:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16521 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758411Ab2CBPPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:15:25 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=iqH1YQEIiWMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=-YWViM8aX__MD2ynLhoA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330701323.25686.260.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 7/9][RFC] [PATCH 7/9] cpu/rt: Rework cpu down for
 PREEMPT_RT
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>
Date: Fri, 02 Mar 2012 10:15:23 -0500
In-Reply-To: <alpine.LFD.2.02.1203021518501.2742@ionos>
References: <20120301185527.064629423@goodmis.org>
	 <20120301190346.172835662@goodmis.org>
	 <alpine.LFD.2.02.1203021518501.2742@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 15:52 +0100, Thomas Gleixner wrote:

> So no, I rather keep the current problem than applying that insanity.

Note, patches 1,2,3,5 and 6, were bugs I found while debugging hotplug.
Please add them, they are not insanity fixes but real bug fixes.

And can you mark them as stable-rt fixes too.

Thanks,

-- Steve


