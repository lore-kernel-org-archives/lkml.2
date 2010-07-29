Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab0G2Ka4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:30:56 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:35660 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab0G2Kaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:30:55 -0400
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ftrace: record command lines at more appropriate moment
From: Ian Munsie <imunsie@au1.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
In-reply-to: <20100729015832.GC13088@nowhere>
References: <1280284180-17863-1-git-send-email-imunsie@au1.ibm.com> <4C4F9C3A.6020406@cn.fujitsu.com> <1280317404-sup-4657@au1.ibm.com> <20100729015832.GC13088@nowhere>
Date: Thu, 29 Jul 2010 20:30:32 +1000
Message-Id: <1280399185-sup-1032@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Frederic Weisbecker's message of Thu Jul 29 11:58:34 +1000 2010:
> In fact I don't really understand what is this tp_benchmark function, when and
> where is it called?

The idea was just to replace a single tracepoint with a call to a
separate function (who's sole action was to call the tracepoint) so that
the ftrace function profiler could profile that function and provide
average timing data for the function call + tracepoint, i.e. like:

noinline void tp_benchmark(...)
{
	trace_...
}

Mostly just laziness on my part really.

> But anyway, I'll rather comment the idea on the patch.

Cheers,
-Ian
