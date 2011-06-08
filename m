Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab1FHDlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:41:09 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38260 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1FHDlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:41:07 -0400
X-AuditID: b753bd60-a46c9ba000003bac-84-4deeef4e66f6
X-AuditID: b753bd60-a46c9ba000003bac-84-4deeef4e66f6
Message-ID: <4DEEEF4C.2000404@hitachi.com>
Date: Wed, 08 Jun 2011 12:41:00 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: ananth@in.ibm.com
Cc: Christoph Hellwig <hch@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 20/22] 20: perf: perf interface for	uprobes
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6> <20110607130216.28590.5724.sendpatchset@localhost6.localdomain6> <20110607133039.GA4929@infradead.org> <20110607133853.GC9949@in.ibm.com>
In-Reply-To: <20110607133853.GC9949@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/07 22:38), Ananth N Mavinakayanahalli wrote:
> On Tue, Jun 07, 2011 at 09:30:39AM -0400, Christoph Hellwig wrote:
>> On Tue, Jun 07, 2011 at 06:32:16PM +0530, Srikar Dronamraju wrote:
>>>
>>> Enhances perf probe to user space executables and libraries.
>>> Provides very basic support for uprobes.
>>
>> Nice.  Does this require full debug info for symbolic probes,
>> or can it also work with simple symbolc information?
> 
> It works only with symbol information for now.
> It doesn't (yet) know how to use debuginfo :-)

So we can enhance it to use debuginfo for obtaining
variables or line numbers from debuginfo. since
probe-finder already has the analysis part, I think
it's not hard to support userspace apps.

Thanks!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
