Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab1AFABI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:01:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62261 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab1AFABF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:01:05 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=1QUcRLxQR78A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=vmLDa1wCAAAA:8 a=qwMUthKI3AZ_Z8ReS-wA:9 a=vSjGgPGZXbFZk3-4TE4A:7 a=S4PWLXTGQ21gBgL5FCadjGT4wdsA:4 a=PUjeQqilurYA:10 a=gv_BBZfBKR8A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC patch 2/5] trace event skb fix unassigned field
From: Steven Rostedt <rostedt@goodmis.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Zhaolei <zhaolei@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110105115908.GA4434@hmsreliant.think-freely.org>
References: <E1PaGZY-0001EI-BD@smtp.tuxdriver.com>
	 <20110104235418.GD2911@nowhere> <20110105004038.GB9737@Krystal>
	 <20110105004903.GF2911@nowhere> <20110105012123.GA10416@Krystal>
	 <20110105115908.GA4434@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 05 Jan 2011 19:01:04 -0500
Message-ID: <1294272064.26623.154.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 06:59 -0500, Neil Horman wrote:

> > Yep, leading to this patch instead:
> > 
> > trace event skb remove duplicate null-pointer check
> > 
> > The check for NULL skb in the kfree_skb trace event is a duplicate from the
> > check already done in its only caller, kfree_skb(). Remove this duplicate check.
> > 

> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Mathieu, can you repost this as a non-RFC patch, and include Neil's
acked-by.

Thanks,

-- Steve


