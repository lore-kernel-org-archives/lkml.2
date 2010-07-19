Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966801Ab0GSVCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:02:34 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63994 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966763Ab0GSVCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:02:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6048"; a="47963581"
Subject: Re: [PATCH 1/4] posix-timers: Refactoring of CPUCLOCK* macros
From: Daniel Walker <dwalker@codeaurora.org>
To: Tomasz Buchert <Tomasz.Buchert@inria.fr>
Cc: linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <4C44BC9E.30202@inria.fr>
References: <1279539289-27628-1-git-send-email-tomasz.buchert@inria.fr>
	 <1279539289-27628-2-git-send-email-tomasz.buchert@inria.fr>
	 <1279564962.21763.8.camel@c-dwalke-linux.qualcomm.com>
	 <4C44BC9E.30202@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 14:02:28 -0700
Message-ID: <1279573348.21763.9.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-19 at 22:59 +0200, Tomasz Buchert wrote:
> Daniel Walker a écrit :
> > On Mon, 2010-07-19 at 13:34 +0200, Tomasz Buchert wrote:
> >> This is merely a preparation to introduce wall time
> >> clocks for threads/processes. All occurences of
> >> CPUCLOCK* macros were replaced by CLOCK*.
> > 
> > It seems like it would be better to make this naming more specific that
> > less. Couldn't you say "POSIX_CLOCK" or something like that?
> > 
> > Daniel
> Hi Daniel.
> Sure. However, technically, my wall clocks have nothing to do
> with POSIX. Still the code is inside a file with "posix" prefix,
> so you are right.
> I will resend patch series as soon as it is done. Could you
> elaborate on another patches?

I wasn't suggesting that adding "POSIX" is the only option, but adding
something more so it's not just "CLOCK" .

You mean you want me to review the other patches also ? 

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

