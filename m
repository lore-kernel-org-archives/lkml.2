Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab1ECWyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:54:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43480 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1ECWym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:54:42 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=7nOEvyL692QA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=efay6nEPsLPRtCsF-aMA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2] x86: Change trap definitions to enumerated values
From: Steven Rostedt <rostedt@goodmis.org>
To: Michael Rubin <mrubin@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, Don Zickus <dzickus@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Aditya Kali <adityakali@google.com>
In-Reply-To: <BANLkTik4N_cWuw2Vq65UX5jCW+AccQHAHw@mail.gmail.com>
References: <1303513438-26519-1-git-send-email-vnagarnaik@google.com>
	 <1304124773-24935-1-git-send-email-vnagarnaik@google.com>
	 <20110503131820.GB23498@redhat.com>
	 <BANLkTinqHNCzcZmQL6M-pCszTmPO=-X8yw@mail.gmail.com>
	 <BANLkTik4N_cWuw2Vq65UX5jCW+AccQHAHw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 03 May 2011 18:54:36 -0400
Message-ID: <1304463276.25414.2420.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 15:41 -0700, Michael Rubin wrote:
> On Tue, May 3, 2011 at 12:00 PM, Vaibhav Nagarnaik
> <vnagarnaik@google.com> wrote:
> > Would it make better sense to separate this patch into 2 patches, the first
> > one replacing the numbers to enums and the second one adding the tracepoints?
> 
> Yes please do that.
> Each patch should stand on its own with one simple purpose if possible.

Agreed. Don't break up patches just because of size, but instead with
purpose. Usually this breaks up large patches as you want to build up
something, piece by piece, where each piece has a specific, easy to
understand goal.

This is actually what is taking me so long to get my ftrace rewrite out.
Not the actual work, but coming up with a way to break up that work in
logical steps, that makes it easy to understand and review.

-- Steve


