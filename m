Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2E3Gjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 02:39:33 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42049 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2E3Gjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 02:39:32 -0400
X-AuditID: b753bd60-92bfeba000003d24-1a-4fc5c0a0a5eb
X-AuditID: b753bd60-92bfeba000003d24-1a-4fc5c0a0a5eb
Message-ID: <4FC5C09C.6030703@hitachi.com>
Date: Wed, 30 May 2012 15:39:24 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH -tip 2/9] ftrace/x86-64: support SAVE_REGS feature
 on x86-64
References: <20120529124833.9191.23007.stgit@localhost.localdomain>  <20120529124905.9191.91563.stgit@localhost.localdomain> <1338332727.13348.301.camel@gandalf.stny.rr.com>
In-Reply-To: <1338332727.13348.301.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/30 8:05), Steven Rostedt wrote:
> No! Please do not make ftrace save all regs for everyone. This is
> critical. This will slow down function tracing even more. We do not need
> to save all regs for every function call, unless it is asked for.

Indeed, I have just removed your save_regs dynamic selector code,
because I'd like to make this series as simple as possible
for review.

> It should only save all regs if the ftrace_ops that is registered asked
> for it. I had code that actually does that. I can merge your patches
> with them if you would like.

Yes, I'd like :)

BTW, that code which dynamically selects trace_caller on your
ftrace-v2 tree, seems to be an uncompleted work. Would you
already have done it?

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
