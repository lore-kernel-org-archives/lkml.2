Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab1G1MtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 08:49:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:41547 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab1G1MtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 08:49:16 -0400
Subject: Re: [PATCH v2 0/6] Add tracepoints to trace all system IRQs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <20110728123131.GA11820@somewhere.redhat.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
	 <1311793038-15155-1-git-send-email-vnagarnaik@google.com>
	 <1311855169.2617.168.camel@laptop>
	 <20110728123131.GA11820@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 14:53:52 +0200
Message-ID: <1311857632.2617.172.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 14:31 +0200, Frederic Weisbecker wrote:
> 
> Because that requires to put the tracepoints in every interrupt sources
> for every archs instead of putting one in the generic space. 

Yeah so, he needs to touch arch code anyway.

As it stands this patch-set is an utter trainwreck and isn't going
anywhere.

