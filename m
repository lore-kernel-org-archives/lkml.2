Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842Ab2EWS4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:56:09 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50512 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab2EWS4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:56:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120523185054.GA17700@gmail.com>
References: <20120523185054.GA17700@gmail.com>
Date: Wed, 23 May 2012 14:56:06 -0400
Message-ID: <CA+5PVA5m5U67mt8mXH_i_2Zu7OuVWiHfR82kBwqJm5ey4R26sg@mail.gmail.com>
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

On Wed, May 23, 2012 at 2:50 PM, Ingo Molnar <mingo@kernel.org> wrote:
> Linus,
>
> Please pull the latest perf-urgent-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus
>
>   HEAD: 5bcdf5e4fee3c45e1281c25e4941f2163cb28c65 perf/x86: Update event scheduling constraints for AMD family 15h models
>
> Leftover AMD PMU driver fix fix from the end of the v3.4
> stabilization cycle.

Perf doesn't even build in Linus' current tree.  You might want to include

http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commitdiff;h=8784eb7497b928de33a715e26da2bd51d424bec1

with your pull request.

josh
