Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab1JDRml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:42:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44548 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932703Ab1JDRmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:42:40 -0400
Date: Tue, 4 Oct 2011 19:42:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        acme <acme@ghostprotocols.net>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
Message-ID: <20111004174234.GG14482@one.firstfloor.org>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com> <1316778523.9084.17.camel@twins> <20110923122014.GP6063@erda.amd.com> <1317716839.25926.12.camel@twins> <20111004085409.GA18566@elte.hu> <m2botwlnfk.fsf@firstfloor.org> <1317746709.32543.23.camel@twins> <20111004171603.GI21506@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004171603.GI21506@erda.amd.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 07:16:03PM +0200, Robert Richter wrote:
> On 04.10.11 12:45:09, Peter Zijlstra wrote:
> > I would much prefer perf {ibs,pebs} commands implemented in C, so that
> > normal people can change/improve them too.
> 
> Would a perf {ibs,pebs} be an ascii dump or so? Then I just would

You would need a script to post process that anyways, that is why
the idea was to put it into perf script (with a suitable default)
But the default could be also written in C if Peter prefers that.

-Andi

