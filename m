Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab1FJGPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 02:15:24 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:34384 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1FJGPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 02:15:23 -0400
X-AuditID: b753bd60-a50caba000003bac-a7-4df1b67792c0
X-AuditID: b753bd60-a50caba000003bac-a7-4df1b67792c0
Message-ID: <4DF1B668.2020002@hitachi.com>
Date: Fri, 10 Jun 2011 15:15:04 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 0/22]  0: Uprobes patchset with perf probe
 support
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6> <1307660596.2497.1760.camel@laptop>
In-Reply-To: <1307660596.2497.1760.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/10 8:03), Peter Zijlstra wrote:
> On Tue, 2011-06-07 at 18:28 +0530, Srikar Dronamraju wrote:
>> Please do provide your valuable comments.
> 
> Your patch split-up is complete crap. I'm about to simply fold all of
> them just to be able to read anything.
> 
> The split-up appears to do its best to make it absolutely impossible to
> get a sane overview of things, tons of things are out of order, either
> it relies on future patches filling out things or modifies stuff in
> previous patches.
> 
> Its a complete pain to read..


Maybe for the part of uprobe itself, you are right.
But I hope tracing/perf parts are separated from that.

Thanks,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
