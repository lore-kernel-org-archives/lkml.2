Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab1ECPgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:36:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52169 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab1ECPgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:36:20 -0400
Message-ID: <4DC020D9.3050000@zytor.com>
Date: Tue, 03 May 2011 08:35:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86: Allow the user not to build hw_breakpoints
References: <1303923602-2923-1-git-send-email-fweisbec@gmail.com> <1303923602-2923-4-git-send-email-fweisbec@gmail.com> <4DB854AA.6070101@zytor.com> <20110427182633.GB1753@nowhere> <008d59a3-bd23-4cb3-8a73-1640137e3ac4@email.android.com> <20110427195004.GA3654@nowhere>
In-Reply-To: <20110427195004.GA3654@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 12:50 PM, Frederic Weisbecker wrote:
> On Wed, Apr 27, 2011 at 11:54:17AM -0700, H. Peter Anvin wrote:
>> Why do you have to be able to disable breakpoints to disable perf? That seems seriously backwards, especially since we had breakpoints long before perf...
> 
> That started when we implemented breakpoints as counters. Then we realized that
> ptrace had its own scheduling that was somehow duplicating what perf was doing.
> So we have finally unified that under perf. The good point is that archs don't need
> to care much about ptrace breakpoints tracking, just the interface.
> 
> But yeah the bad point is that dependency.

It really is very bad... without breakpoints, you lose almost all
debugging support.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

