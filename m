Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0DDNHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 09:07:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab0DDNHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 09:07:42 -0400
X-Authority-Analysis: v=1.1 cv=W8jVbnnOFeMnsvu+vJfVVAGaiNyfzTaRLlU2b8ifu+8= c=1 sm=0 a=EQ1AM5h6K_EA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=lAxKj2r9-7R74TIMcjUA:9 a=Nfiv-ReY6yriVz0NdT0gBPwxos8A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] oprofile: remove double ring buffering
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100404100108.GA18855@one.firstfloor.org>
References: <20100401011725.GA27567@basil.fritz.box>
	 <20100401190205.GD6027@erda.amd.com>
	 <1270149084.19685.9249.camel@gandalf.stny.rr.com>
	 <20100404100108.GA18855@one.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sun, 04 Apr 2010 09:07:38 -0400
Message-ID: <1270386458.19685.13247.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-04-04 at 12:01 +0200, Andi Kleen wrote:

> > Note, I just sent out a patch set yesterday which will conflict with
> > this change.
> > 
> > I Cc'd both you and Andi on that patch.
> 
> Steve, is your ring buffer patch intended for stable? 
> 
> I plan to submit the oprofile patch for stable and if your is not
> it would be more convenient if your patch was based on mine instead
> of the other way round. If yours is for stable I can rebase on top
> of yours.

No, my patch is not intended for stable, and in fact, is intended for
35.

When yours gets into Linus's tree, we can fix the conflict. It should be
trivial to fix, since the conflict is just me adding another parameter
(NULL) to a function you changed.

I just wanted you to be aware of the change, you don't need to do
anything about it.

-- Steve




