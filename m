Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847Ab1JNTca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:32:30 -0400
Received: from intmgw001.ash2.facebook.com ([66.220.155.178]:47659 "EHLO
	intmgw001.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932715Ab1JNTc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:32:29 -0400
Date: Fri, 14 Oct 2011 12:12:27 -0700
From: Arun Sharma <asharma@fb.com>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 2/4] trace: prepare to collect call chains of non-current
 task.
Message-ID: <20111014191227.GB23666@dev1756.snc6.facebook.com>
References: <1317052535-1765247-1-git-send-email-avagin@openvz.org>
 <1317052535-1765247-3-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317052535-1765247-3-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 07:55:33PM +0400, Andrew Vagin wrote:
> This patch adds argument "task" to all functions between perf_tp_event()
> and perf_callchain(). All logic is in the next patch.
> 
> We need "task" and "regs" simultaneously, because regs contains
> state of current task, before it entered in perf code. Task contains
> pointer to task_struct and it will be used for collecting call chains
> and filling event data, if task isn't current.
> 
> Signed-off-by: Andrew Vagin <avagin@openvz.org>

Acked-by: Arun Sharma <asharma@fb.com>

