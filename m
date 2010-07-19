Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966778Ab0GSU7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 16:59:16 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:7008 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966729Ab0GSU7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 16:59:15 -0400
X-IronPort-AV: E=Sophos;i="4.55,228,1278280800"; 
   d="scan'208";a="54486579"
Message-ID: <4C44BC9E.30202@inria.fr>
Date: Mon, 19 Jul 2010 22:59:10 +0200
From: Tomasz Buchert <Tomasz.Buchert@inria.fr>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] posix-timers: Refactoring of CPUCLOCK* macros
References: <1279539289-27628-1-git-send-email-tomasz.buchert@inria.fr>	 <1279539289-27628-2-git-send-email-tomasz.buchert@inria.fr> <1279564962.21763.8.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1279564962.21763.8.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker a écrit :
> On Mon, 2010-07-19 at 13:34 +0200, Tomasz Buchert wrote:
>> This is merely a preparation to introduce wall time
>> clocks for threads/processes. All occurences of
>> CPUCLOCK* macros were replaced by CLOCK*.
> 
> It seems like it would be better to make this naming more specific that
> less. Couldn't you say "POSIX_CLOCK" or something like that?
> 
> Daniel
Hi Daniel.
Sure. However, technically, my wall clocks have nothing to do
with POSIX. Still the code is inside a file with "posix" prefix,
so you are right.
I will resend patch series as soon as it is done. Could you
elaborate on another patches?

Tomek

