Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab1JMOAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:00:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57664 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab1JMOAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:00:15 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=NFX316_vVeIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=J7-p8CfoAc0K6OV2Y5cA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318514413.12224.7.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/2 v2] [GIT PULL][v3.2] tracing: queued updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 13 Oct 2011 10:00:13 -0400
In-Reply-To: <1318514142.12224.5.camel@gandalf.stny.rr.com>
References: <20111011152026.701326733@goodmis.org>
	 <20111012081629.GA25086@elte.hu>
	 <1318418515.13262.21.camel@gandalf.stny.rr.com>
	 <1318425974.13262.26.camel@gandalf.stny.rr.com>
	 <20111012162320.GA31857@elte.hu> <20111013085936.GA13046@elte.hu>
	 <1318514142.12224.5.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-13 at 09:55 -0400, Steven Rostedt wrote:

> > there's a cross-build failure on the m32r architecture:
> 
> Hmm, I don't have a m32r cross compiler in my arsenal.

Ah, I didn't see a 4.5.2 m32r binary cross compiler, but there is a
4.5.1. I'll add this to my tool chain.

Thanks!

-- Steve


