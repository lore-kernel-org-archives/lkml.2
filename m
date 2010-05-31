Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab0EaTQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:16:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59538 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab0EaTQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:16:34 -0400
X-Authority-Analysis: v=1.1 cv=WC2cwRI/KXdLNEmE8ivg2cmI8vFt6dWmaZdvaJ93QHU= c=1 sm=0 a=bhrI7EF9pE8A:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=0sKjk8XQrMeuGpXQdC4A:9 a=qwGT80QRSpGmD67hzMjcF-YCnI4A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: Add task activate/deactivate tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1275330522.1645.523.camel@laptop>
References: <1275056762-13130-1-git-send-regression-fweisbec@gmail.com>
	 <1275059710.27810.9624.camel@twins> <20100531080049.GA435@elte.hu>
	 <1275293544.27810.21478.camel@twins> <1275296099.27810.21622.camel@twins>
	 <20100531143622.GA5157@nowhere> <1275317013.27810.23019.camel@twins>
	 <20100531144820.GB5157@nowhere>  <1275322715.27810.23323.camel@twins>
	 <1275323853.15884.14.camel@gandalf.stny.rr.com>
	 <1275330522.1645.523.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 31 May 2010 15:16:32 -0400
Message-ID: <1275333392.15884.16.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 20:28 +0200, Peter Zijlstra wrote:
> On Mon, 2010-05-31 at 12:37 -0400, Steven Rostedt wrote:

> > Maybe I'm a bit paranoid, but I'm a little nervous to extend the
> > CREATE_TRACE_POINTS macro to be used within the header to create utility
> > functions, although, currently I don't think there's anything
> > technically wrong in doing so. 
> 
> Right, I can attest to the compile mess that results in not having
> it :-) Given that, I think we're fairly safe with stretching it like
> this, the compiler will yell real loud if you mess this up. So I'm not
> sure you need to be very paranoid about this.

Actually, I'm not worried about getting the utility functions right. I'm
actually more worried about extending TRACE_EVENT() and having this be a
thorn in our side when doing so.

-- Steve


