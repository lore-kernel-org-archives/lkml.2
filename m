Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab1EFV3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:29:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932718Ab1EFV3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:29:54 -0400
MIME-Version: 1.0
In-Reply-To: <1304716461.25414.2542.camel@gandalf.stny.rr.com>
References: <4DC45537.6070609@linux.intel.com>
	<1304713252.25414.2532.camel@gandalf.stny.rr.com>
	<BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
	<1304716461.25414.2542.camel@gandalf.stny.rr.com>
Date: Fri, 6 May 2011 14:28:54 -0700
Message-ID: <BANLkTinazaXRdGovYL7rRVp+j6HbJ7pzhg@mail.gmail.com>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/11, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Note, at last Kernel Summit, you pointed at my slide of the trace event
> ASCII format, and stated, "That's the ABI". What happend now?

That whole reality thing again?

Clearly it didn't end up as the ABI. We have programs that use that
ABI and thus it's a regression if they break.

          Linus
