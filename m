Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab0EaTOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:14:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50028 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121Ab0EaTOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:14:46 -0400
X-Authority-Analysis: v=1.1 cv=Pm0qIGCwx3bIEOZlSg1a56K3RSwKBTW9sPEb+DFvEKk= c=1 sm=0 a=bhrI7EF9pE8A:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=ihXRDxzDkn8MaITlAsQA:9 a=LUQQYl-ebIRSwNhLc2Z7tyN2E_AA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
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
Date: Mon, 31 May 2010 15:14:44 -0400
Message-ID: <1275333284.15884.15.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 20:28 +0200, Peter Zijlstra wrote:
> On Mon, 2010-05-31 at 12:37 -0400, Steven Rostedt wrote:
> > >  

> So do you object if I merge this for now, or would you really rather see
> something else?
> 

No, I don't object.

Cautiously-acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


