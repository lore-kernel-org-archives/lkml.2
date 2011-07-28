Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab1G1NJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:09:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36852 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab1G1NJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:09:33 -0400
Date: Thu, 28 Jul 2011 15:09:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 0/6] Add tracepoints to trace all system IRQs
Message-ID: <20110728130925.GB11820@somewhere.redhat.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
 <1311793038-15155-1-git-send-email-vnagarnaik@google.com>
 <1311855169.2617.168.camel@laptop>
 <20110728123131.GA11820@somewhere.redhat.com>
 <1311857632.2617.172.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311857632.2617.172.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 02:53:52PM +0200, Peter Zijlstra wrote:
> On Thu, 2011-07-28 at 14:31 +0200, Frederic Weisbecker wrote:
> > 
> > Because that requires to put the tracepoints in every interrupt sources
> > for every archs instead of putting one in the generic space. 
> 
> Yeah so, he needs to touch arch code anyway.

He needs to touch arch code for pure arch interrupts or some cases
where we don't have the choice. But otherwise there are many
cases where we can put that in the generic code.

> 
> As it stands this patch-set is an utter trainwreck and isn't going
> anywhere.
> 
