Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab2J0TmN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 15:42:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab2J0TmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 15:42:11 -0400
Date: Sat, 27 Oct 2012 21:42:00 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        eranian@google.com, mingo@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 31/33] perf, tools: Support generic events as pmu event
 names v2
Message-ID: <20121027194200.GD1039@krava.redhat.com>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
 <1351283415-13170-32-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351283415-13170-32-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 01:30:13PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Extend the parser/lexer to allow generic event names like
> "instructions" as a sysfs supplied PMU event name.
> 
> This resolves the problem that cpu/instructions/ gives a parse
> error, even when the kernel supplies a "instructions" event
> 
> This is useful to add sysfs specified qualifiers to these
> events, for example cpu/instructions,intx=1/ and needed
> for the TSX events
> 
> Simply extend the grammar to handle this case. The lexer
> needs minor changes to save the original string.

ops, I think you need to check recent changes:

3f3a206 perf test: Add automated tests for pmu sysfs translated events
1d33d6d perf tools: Add support to specify hw event as PMU event term
3fded96 perf tools: Fix PMU object alias initialization
20550a4 perf/x86: Add hardware events translations for Intel P6 cpus
0bf79d4 perf/x86: Add hardware events translations for AMD cpus
43c032f perf/x86: Add hardware events translations for Intel cpus
8300daa perf/x86: Filter out undefined events from sysfs events attribute
a474739 perf/x86: Make hardware event translations available in sysfs

jirka
