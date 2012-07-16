Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2GPNOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:14:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33495 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab2GPNOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:14:37 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=-wGngUE2Vx8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=j1DuTkQlEEml-urffykA:9 a=PUjeQqilurYA:10 a=HwYIqS5PF7ksqJeP:21 a=0DkMwRObrIo-P5U2:21 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342444475.21617.2.camel@gandalf.stny.rr.com>
Subject: Re: [patch RT 0/3] Stable rt updates - part II
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        RT-users <linux-rt-users@vger.kernel.org>
Date: Mon, 16 Jul 2012 09:14:35 -0400
In-Reply-To: <20120715090141.942753287@linutronix.de>
References: <20120715090141.942753287@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 08:07 +0000, Thomas Gleixner wrote:
> Steven,
> 
> please pick the following three patches which address the CPU hotplug
> nightmare on RT.

OK, I'll process this after releasing v3.2.22-rt35 and v3.2.23-rt36.

> 
> I still hate them, but we want to have that addressed in the stable
> series.

I'm glad they were useful.

> 
> Aside of that there are the outstanding issues with btrfs and io unplug.

Right, I was holding off releasing a 3.0 series because of this.

> 
> The missing spin_lock_init() fix should reach you via mainline stable
> updates. Mike and Chris are looking into that interesting locking
> features.
> 
> The io unplug thing stays mysterious, but as I just wrote in that
> thread, my patch to address it is fundamentally wrong. :(
> 
> I'm off for a week of vacation, so do not expect any further updates
> from my side. If Mike and Chris come up with an agreed solution for
> the locking issue, please pick it up yourself.

OK, but I'll be hounding you when you get back. Although I'll be off
next week.

-- Steve


