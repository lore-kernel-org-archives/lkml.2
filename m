Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965163Ab2EWS5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:57:40 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65104 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab2EWS5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:57:39 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA5m5U67mt8mXH_i_2Zu7OuVWiHfR82kBwqJm5ey4R26sg@mail.gmail.com>
References: <20120523185054.GA17700@gmail.com>
	<CA+5PVA5m5U67mt8mXH_i_2Zu7OuVWiHfR82kBwqJm5ey4R26sg@mail.gmail.com>
Date: Wed, 23 May 2012 14:57:38 -0400
Message-ID: <CA+5PVA42MrsVxkyB5dVPSF99GZZVuDxVdB6tJsZyVvP90DDcMA@mail.gmail.com>
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

On Wed, May 23, 2012 at 2:56 PM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Wed, May 23, 2012 at 2:50 PM, Ingo Molnar <mingo@kernel.org> wrote:
>> Linus,
>>
>> Please pull the latest perf-urgent-for-linus git tree from:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus
>>
>>   HEAD: 5bcdf5e4fee3c45e1281c25e4941f2163cb28c65 perf/x86: Update event scheduling constraints for AMD family 15h models
>>
>> Leftover AMD PMU driver fix fix from the end of the v3.4
>> stabilization cycle.
>
> Perf doesn't even build in Linus' current tree.  You might want to include
>
> http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commitdiff;h=8784eb7497b928de33a715e26da2bd51d424bec1

Possibly this one too:

http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commitdiff;h=e326e7524531c5c6de4a8cf8eeed60b4a9f47637

josh
