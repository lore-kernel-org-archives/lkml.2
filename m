Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966807Ab0GSVLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:11:45 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:33587 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936504Ab0GSVLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:11:43 -0400
X-IronPort-AV: E=Sophos;i="4.55,228,1278280800"; 
   d="scan'208";a="55812634"
Message-ID: <4C44BF8D.2020002@inria.fr>
Date: Mon, 19 Jul 2010 23:11:41 +0200
From: Tomasz Buchert <Tomasz.Buchert@inria.fr>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] posix-timers: Refactoring of CPUCLOCK* macros
References: <1279539289-27628-1-git-send-email-tomasz.buchert@inria.fr>	 <1279539289-27628-2-git-send-email-tomasz.buchert@inria.fr>	 <1279564962.21763.8.camel@c-dwalke-linux.qualcomm.com>	 <4C44BC9E.30202@inria.fr> <1279573348.21763.9.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1279573348.21763.9.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker a écrit :
> On Mon, 2010-07-19 at 22:59 +0200, Tomasz Buchert wrote:
>> Daniel Walker a écrit :
>>> On Mon, 2010-07-19 at 13:34 +0200, Tomasz Buchert wrote:
>>>> This is merely a preparation to introduce wall time
>>>> clocks for threads/processes. All occurences of
>>>> CPUCLOCK* macros were replaced by CLOCK*.
>>> It seems like it would be better to make this naming more specific that
>>> less. Couldn't you say "POSIX_CLOCK" or something like that?
>>>
>>> Daniel
>> Hi Daniel.
>> Sure. However, technically, my wall clocks have nothing to do
>> with POSIX. Still the code is inside a file with "posix" prefix,
>> so you are right.
>> I will resend patch series as soon as it is done. Could you
>> elaborate on another patches?
> 
> I wasn't suggesting that adding "POSIX" is the only option, but adding
> something more so it's not just "CLOCK" .
> 
> You mean you want me to review the other patches also ? 
> 
> Daniel
> 
"POSIX" looks good to me.
Reviewing the other patches would be great, because they actually do real stuff.

Tomek


