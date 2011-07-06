Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1GFX4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:56:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37956 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1GFX4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:56:21 -0400
Date: Thu, 7 Jul 2011 01:56:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v2] trace: Add x86 irq vector entry/exit tracepoints
Message-ID: <20110706235613.GA21115@somewhere>
References: <1304107962-18576-1-git-send-email-vnagarnaik@google.com>
 <1306877298-31713-1-git-send-email-vnagarnaik@google.com>
 <20110531235957.GB5256@somewhere.redhat.com>
 <BANLkTi=YYCXHi5k82Q+sE6+134i97pjjAA@mail.gmail.com>
 <BANLkTinT6ULRWwHAGYFpQSw-ptQiuzrkPtZuKVZHD8b5mh9hpA@mail.gmail.com>
 <20110616030200.GC18579@somewhere.redhat.com>
 <4E14F31B.4080102@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E14F31B.4080102@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 04:43:23PM -0700, H. Peter Anvin wrote:
> On 06/15/2011 08:02 PM, Frederic Weisbecker wrote:
> > 
> > If a generic tracepoint can replace one per arch, we all want that instead.
> > This is 24 times (24 archs) less maintainance burden.
> > 
> 
> Are you in effect saying that tracepoints are now a stable ABI?  They
> sure as hell haven't been architected, reviewed, or accepted for any
> such purpose.

Nope, I'm rather suggesting that it's better to have 1 line of code instead of 24.

And even if tracepoints are not supposed to be stable ABI (I actually believe there
is no absolute answer to that, it depends on the tracepoint and on the context),
tools are much happier with a common tracepoint interface amongst archs.
