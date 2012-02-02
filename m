Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab2BBOLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 09:11:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49032 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094Ab2BBOLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 09:11:06 -0500
Message-ID: <4F2A9960.2090500@zytor.com>
Date: Thu, 02 Feb 2012 06:10:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and
 2 or 5 byte nops
References: <20120128160925.275163704@goodmis.org> <20120130144857.GA22013@elte.hu> <1327936060.22710.165.camel@gandalf.stny.rr.com> <20120131194813.GA12074@elte.hu> <1328072925.5882.57.camel@gandalf.stny.rr.com> <20120201080539.GA11770@elte.hu> <1328109697.5882.65.camel@gandalf.stny.rr.com> <20120202135154.GA10315@elte.hu>
In-Reply-To: <20120202135154.GA10315@elte.hu>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 05:51 AM, Ingo Molnar wrote:
> [    0.000000] Unexpected op at enqueue_task_fair+0xab/0x1fb [ffffffff81078a8d] (0f 1f 44 00 00) arch/x86/kernel/jump_label.c:74

So this is presumably the expected NOP... what was it expecting instead?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

