Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946152Ab2EROT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:19:57 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:55575 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946137Ab2EROTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:19:54 -0400
X-AuditID: b753bd60-98392ba000007b1b-8d-4fb65a880c6a
X-AuditID: b753bd60-98392ba000007b1b-8d-4fb65a880c6a
Message-ID: <4FB65A85.8070700@hitachi.com>
Date: Fri, 18 May 2012 23:19:49 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 12/15] ftrace: Return record ip addr for ftrace_location()
References: <20120518130858.392919640@goodmis.org> <20120518131051.251652937@goodmis.org>
In-Reply-To: <20120518131051.251652937@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/18 22:09), Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> ftrace_location() is passed an addr, and returns 1 if the addr is
> on a ftrace nop (or caller to ftrace_caller), and 0 otherwise.
> 
> To let kprobes know if it should move a breakpoint or not, itH
> must return the actual addr that is the start of the ftrace nop.
> This way a kprobe placed on the location of a ftrace nop, can
> instead be placed on the instruction after the nop. Even if the
> probe addr is on the second or later byte of the nop, it can
> simply be moved forward.
> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

This looks good to me:)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

P.S.
 Steven, ftrace-based optimization is under development with both
 i386/x86-64 support :)

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
