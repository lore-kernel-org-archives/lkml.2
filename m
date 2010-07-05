Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0GEObG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 10:31:06 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54860 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab0GEObD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 10:31:03 -0400
Subject: Re: [PATCH -tip 0/4] perf-probe updates: string support, etc.
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Chase Douglas <chase.douglas@canonical.com>
In-Reply-To: <20100519195717.2885.90799.stgit@localhost6.localdomain6>
Date: Mon, 5 Jul 2010 10:30:47 -0400
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Content-Transfer-Encoding: 7bit
Message-Id: <56FC4434-EA6C-4A0C-A95B-3D7BE818774B@canonical.com>
References: <20100519195717.2885.90799.stgit@localhost6.localdomain6>
To: Masami Hiramatsu <mhiramat@redhat.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 19, 2010, at 3:57 PM, Masami Hiramatsu wrote:
> Hi,
> 
> Here is a series of patches which improves perf probe to
> add below features. I cleared some coding style issues.
> 
> - String support, which enables dynamic events to trace string
>  variables instead of its address.
> 
> - Fixed-index array entry support, which allows user to trace
>  an array entry with digit index, e.g. array[0].
> 
> - Global/static variable support, which allows user to trace
>  global or static variables, as same as local one.
> 
> 
> TODOs (possible features):
>  - Support dynamic array-indexing (var[var2])
>  - Support force type-casting ((type)var)
>  - Show what deta-structure member is assigned to each argument.
>  - Better support for probes on modules
>  - More debugger like enhancements(%next, --disasm, etc.)
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (4):
>      perf probe: Support static and global variables
>      perf probe: Support tracing an entry of array
>      perf probe: Support "string" type
>      tracing/kprobes: Support "string" type

What's the status of these patches? They seem very useful to me, but I
don't see them in Arnaldo's tree at git.kernel.org.

Thanks,

-- Chase
