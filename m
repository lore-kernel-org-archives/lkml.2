Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab2CEQc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:32:29 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40489 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816Ab2CEQc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:32:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eranian@google.com designates 10.152.132.132 as permitted sender) smtp.mail=eranian@google.com; dkim=pass header.i=eranian@google.com
MIME-Version: 1.0
In-Reply-To: <1330965033.11248.240.camel@twins>
References: <20120224094048.GA7952@quad>
	<20120305154753.GA14604@elte.hu>
	<20120305155011.GA32413@elte.hu>
	<20120305155642.GB32413@elte.hu>
	<1330965033.11248.240.camel@twins>
Date: Mon, 5 Mar 2012 17:32:26 +0100
Message-ID: <CABPqkBQ5iC9TB=W4=19SghYdz9D6z6sXrBerm78TuVwk+W8sBQ@mail.gmail.com>
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, acme@redhat.com,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        asharma@fb.com, robert.richter@amd.com, ming.m.lin@intel.com,
        vweaver1@eecs.utk.edu, andi@firstfloor.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 5:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-03-05 at 16:56 +0100, Ingo Molnar wrote:
>> A third usability bug is that for some reason a branch sampling
>> 'perf report' defaults to the stdio output on my testsystem -
>> with --no-branch-stack it gives the regular tui.
>>
>>
> Ah, I would not have noticed that since I still explicitly build my perf
> without TUI support. That stuff mostly just gets in the way.

I tend to agree with Peter here.

There is no TUI support for branch as of now.

I will fix the other two bugs you reported.
