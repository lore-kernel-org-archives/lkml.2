Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab2A0UvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:51:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51158 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811Ab2A0UvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:51:17 -0500
Message-ID: <4F230E18.2080603@zytor.com>
Date: Fri, 27 Jan 2012 12:50:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 1/5] x86/jump-label: Use best default nops for inital
 jump label calls
References: <20120127201442.080360013@goodmis.org>  <20120127202030.887128048@goodmis.org> <4F230899.3020808@zytor.com> <1327697341.22710.138.camel@gandalf.stny.rr.com>
In-Reply-To: <1327697341.22710.138.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 12:49 PM, Steven Rostedt wrote:
> 
> If not, at the very least, I'll add a comment (in the last patch) that
> explains why we use our own "JUMP_LABEL_INIT_NOP" instead of
> ASM_NOP5_ATOMIC.
> 

Then at least use GENERIC_NOP5_ATOMIC instead of open-coding it.

	-hpa

