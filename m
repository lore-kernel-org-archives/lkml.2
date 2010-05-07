Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0EGImb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:42:31 -0400
Received: from toro.web-alm.net ([62.245.132.31]:50265 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab0EGIm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:42:28 -0400
X-Greylist: delayed 3720 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 May 2010 04:42:28 EDT
Message-ID: <4BE3C292.8040908@osadl.org>
Date: Fri, 07 May 2010 09:34:42 +0200
From: Carsten Emde <Carsten.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fix-taskstates-in-sched_switch-trace.patch
References: <20100311122454.585724424@osadl.org>	 <20100311122822.678489605@osadl.org> <1273187510.22438.67.camel@gandalf.stny.rr.com>
In-Reply-To: <1273187510.22438.67.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

> I just notice that this patch was never applied. Anyone against
> applying it?
Needless to say that I would like to see it applied.

This patch removes duplicate strings and moves all task state related
definitions to a single location to prevent future changes from being
made at one place and omitted at another place.

In addition, if fixes an incorrectly displayed task state of the
sched_switch trace event (which probably was the result of having the
same info at several places).

The principle of this patch made it already into PREEMPT_RT of 2.6.31
and 2.6.33 nearly 3 months ago - and is running smoothly since then.

Thanks for taking care of the patch.

	Carsten.
