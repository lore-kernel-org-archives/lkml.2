Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab0J1OdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:33:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43471 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757047Ab0J1OdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:33:03 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=-qfxTvYugxgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=IOQTed8XBuKQCZCc33gA:9 a=2der4Ktj6TpMskcbJ0g5amXlKmQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: fix TRACE_EVENT power tracepoint creation
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20101028131737.GA20674@Krystal>
References: <20101028021632.GA18117@Krystal>
	 <1288232716.18238.140.camel@gandalf.stny.rr.com>
	 <20101028110321.GA24711@Krystal>
	 <1288270424.18238.211.camel@gandalf.stny.rr.com>
	 <20101028131737.GA20674@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Oct 2010 10:33:01 -0400
Message-ID: <1288276381.18238.265.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 09:17 -0400, Mathieu Desnoyers wrote:

> What you are telling me is that changing the makefiles should be enough, and I
> don't need to add those DEFINE_TRACE(), correct ?

Correct.

-- Steve


