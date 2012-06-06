Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2FFIcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:32:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47070 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab2FFIcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:32:41 -0400
Date: Wed, 6 Jun 2012 10:32:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Vagin <avagin@openvz.org>, Arun Sharma <asharma@fb.com>,
        Oleg Strikov <OSTRIKOV@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 0/5] Teach perf tool to profile sleep times (V4)
Message-ID: <20120606083235.GG5991@gmail.com>
References: <1338797382-287275-1-git-send-email-avagin@openvz.org>
 <1338813658.28282.43.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338813658.28282.43.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> The one thing I'm not entirely sure of is if this is a 
> sekjoerity issue or not.. anybody? I would think a task was 
> entitled to know who woke it and wherefrom etc..

I wouldn't worry about that really in the first approximation. 
/proc already gives out much of that information already.

Thanks,

	Ingo
