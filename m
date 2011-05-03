Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1ECX4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:56:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34147 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab1ECX4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:56:20 -0400
Message-ID: <4DC09613.7030201@zytor.com>
Date: Tue, 03 May 2011 16:56:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86: Allow the user not to build hw_breakpoints
References: <1303923602-2923-1-git-send-email-fweisbec@gmail.com> <1303923602-2923-4-git-send-email-fweisbec@gmail.com> <4DB854AA.6070101@zytor.com> <20110427182633.GB1753@nowhere> <008d59a3-bd23-4cb3-8a73-1640137e3ac4@email.android.com> <20110427195004.GA3654@nowhere> <4DC020D9.3050000@zytor.com> <20110503231241.GG2678@nowhere> <4DC0925E.20507@zytor.com> <20110503235434.GI2678@nowhere>
In-Reply-To: <20110503235434.GI2678@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2011 04:54 PM, Frederic Weisbecker wrote:
> On Tue, May 03, 2011 at 04:40:14PM -0700, H. Peter Anvin wrote:
>> On 05/03/2011 04:12 PM, Frederic Weisbecker wrote:
>>>>
>>>> It really is very bad... without breakpoints, you lose almost all
>>>> debugging support.
>>>
>>> Right, so it should be fine for embedded environment to disable breakpoints.
>>> It depends on CONFIG_EXPERT now.
>>
>> Uh... even embedded environments need to be able to debug.
> 
> For development yeah, but is it needed for production evironments?
> 

Most of the time people don't want to debug something other than they're
going to ship.

	-hpa
