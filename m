Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761851Ab2DLNB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 09:01:58 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35153 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab2DLNB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 09:01:57 -0400
X-AuditID: b753bd60-9518dba000007b1b-fb-4f86d242c2de
X-AuditID: b753bd60-9518dba000007b1b-fb-4f86d242c2de
Message-ID: <4F86D241.1030609@hitachi.com>
Date: Thu, 12 Apr 2012 22:01:53 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] perf/probe: verify instruction/offset in perf before
 adding a uprobe
References: <20120412085748.23484.53789.stgit@nprashan.in.ibm.com> <4F86A060.1010604@linux.vnet.ibm.com>
In-Reply-To: <4F86A060.1010604@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/12 18:29), Prashanth Nageshappa wrote:
> To verify instruction/offset in perf, before adding a uprobe we
> need to use arc/x86/lib/insn.c from perf code. Since perf Makefile
> enables -Wswitch-default flag it causes build warnings/failures. This
> patch is to address the build warnings in insn.c.

Hmm, I see the reason why we need this. However, I think it should have
more correct error checking... I'll try that.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
