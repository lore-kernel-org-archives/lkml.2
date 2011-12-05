Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1LEAba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 19:31:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39694 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab1LEAb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 19:31:29 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=AyFK6pwGKUQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=i25v6YIMuonPfIVnnOYA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 00/10] [GIT PULL] tracing: various fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20111203092043.GA2739@elte.hu>
References: <20111108012939.372220547@goodmis.org>
	 <20111111083339.GD14347@elte.hu> <1322602385.17003.89.camel@frodo>
	 <20111203092043.GA2739@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Dec 2011 19:31:21 -0500
Message-ID: <1323045081.19933.79.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-03 at 10:20 +0100, Ingo Molnar wrote:

> Hm, not all were regression fixes and the branch was named 
> */core so i took it into perf/core.

Yeah it happened just at the end of the merge window. I didn't really
know what branch to name it.

> 
> Could you perhaps cherry-pick the most crutial regression fixes 
> into an urgent branch? We could still push that upstream.

Looking at each patch, I would say 6 of the ten need to go in. Most are
marked as stable since they break the last tree. I could just send them
all to stable if it seems strange to have this many patches in two pull
requests.

-- Steve


