Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699Ab2EWUKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:10:45 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:63476 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796Ab2EWUKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:10:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120523200451.GA19288@gmail.com>
References: <20120523185054.GA17700@gmail.com>
	<CA+5PVA5m5U67mt8mXH_i_2Zu7OuVWiHfR82kBwqJm5ey4R26sg@mail.gmail.com>
	<20120523200451.GA19288@gmail.com>
Date: Wed, 23 May 2012 16:10:30 -0400
Message-ID: <CA+5PVA5gK0bPYbzMQxf3M+X=vuU0510Zechxa6UWcYJot_sP5g@mail.gmail.com>
Subject: Re: [GIT PULL] perf fix
From: Josh Boyer <jwboyer@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 4:04 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Josh Boyer <jwboyer@gmail.com> wrote:
>> Perf doesn't even build in Linus' current tree.
>
> Yes, that's a regression in some build environments. (it builds
> fine in our environments, that's why it wasn't noticed.)
>
>> [...]  You might want to include
>>
>> http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commitdiff;h=8784eb7497b928de33a715e26da2bd51d424bec1
>>
>> with your pull request.
>
> I sent that (and other fixes) to Linus too, earlier today.

I saw that.  Thank you.

> This pull request you replied to is the v3.4 era fixes tree,
> with one remaining fix in it.

I see.  The forest of tip trees apparently confuses me still.  I'll
figure it out eventually.

josh
