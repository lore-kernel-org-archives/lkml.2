Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab1JDQqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:46:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39122 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888Ab1JDQqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:46:19 -0400
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        acme <acme@ghostprotocols.net>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 04 Oct 2011 18:45:09 +0200
In-Reply-To: <m2botwlnfk.fsf@firstfloor.org>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
	 <1316778523.9084.17.camel@twins> <20110923122014.GP6063@erda.amd.com>
	 <1317716839.25926.12.camel@twins> <20111004085409.GA18566@elte.hu>
	 <m2botwlnfk.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317746709.32543.23.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 09:41 -0700, Andi Kleen wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> >
> >  - Testable IBS user-space code a bit more prominently integrated
> >    than having to go down into a cellar with no working lights and 
> >    finding the code on display in tools/perf/Documentation/examples/ 
> >    on the bottom of a locked filing cabinet stuck in a disused
> >    lavatory with a sign on the door saying 'Beware of the Leopard.'
> 
> I looked at this for PEBS, and the best solution currently seems
> to be a python script that works with perf script and does some post
> processing to present the data as summary or individual samples.
> I assume that could work for IBS too.
> 
> Comments?

I would much prefer perf {ibs,pebs} commands implemented in C, so that
normal people can change/improve them too.

I really hate all that snake foo.
