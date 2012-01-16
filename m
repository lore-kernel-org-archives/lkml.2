Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2APHdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 02:33:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49667 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab2APHdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 02:33:12 -0500
Date: Mon, 16 Jan 2012 08:33:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: Remove annoying debug message when restarting
Message-ID: <20120116073307.GC15641@elte.hu>
References: <1326662055-7098-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326662055-7098-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <levinsasha928@gmail.com> wrote:

> This patch removes the "md: stopping all md devices" message when shutting
> down/restarting.
> 
> On Sat, 2012-01-14 at 09:43 +0100, Ingo Molnar wrote:
> > Btw. #2, that annoying 'md: stopping' message should be gotten
> > rid of. Some moron added that to the kernel as a one-day debug
> > printout to debug a software-RAID hang during development of the
> > code, about 15 years ago. (Oh, that was me.)
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
