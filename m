Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab0DATLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:11:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41488 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758691Ab0DATL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:11:27 -0400
X-Authority-Analysis: v=1.1 cv=3DUlJUu7qWFNpNttJVwyA1nQS84iC7EN/BDLX6qJweI= c=1 sm=0 a=EQ1AM5h6K_EA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=7wNUE91lC8_5-q4jRMQA:9 a=FHrOf3uE8p9U79rGa8WZmiDVqlYA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] oprofile: remove double ring buffering
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <20100401190205.GD6027@erda.amd.com>
References: <20100401011725.GA27567@basil.fritz.box>
	 <20100401190205.GD6027@erda.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 01 Apr 2010 15:11:24 -0400
Message-ID: <1270149084.19685.9249.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 21:02 +0200, Robert Richter wrote:
> On 01.04.10 03:17:25, Andi Kleen wrote:
> > Got confirmation now this patch fixes most of the dropped oprofile
> > samples problem on a particular intensive test on a large system.
> > So now submitting the previous RFC formally.
> > .34 / Stable candidate.
> 
> Thanks Andi, will take a look at this next week.

Note, I just sent out a patch set yesterday which will conflict with
this change.

I Cc'd both you and Andi on that patch.

-- Steve


