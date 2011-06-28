Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab1F1NFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 09:05:25 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:34597 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab1F1ND5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 09:03:57 -0400
Date: Tue, 28 Jun 2011 18:33:32 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip 03/13] kprobes: Return -ENOENT if probe point
	doesn't exist
Message-ID: <20110628130332.GA11208@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20110627072626.6528.41792.stgit@fedora15> <20110627072650.6528.67329.stgit@fedora15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627072650.6528.67329.stgit@fedora15>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 04:26:50PM +0900, Masami Hiramatsu wrote:
> Return -ENOENT if probe point doesn't exist, but still returns
> -EINVAL if both of kprobe->addr and kprobe->symbol_name are
> specified or both are not specified.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
