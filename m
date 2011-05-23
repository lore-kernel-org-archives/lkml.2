Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab1EWWK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:10:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33531 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab1EWWKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZiJ8RR1czDoemeZjmpLEz0Tn/3HSuJDwjWlJqSyWPdahOxcO4lDJn338X5bXG8S+2M
         Ve+tqcaDVDCrrPeeIH9fVyf86m1b4sNA4s+aoPjzOPUWdGpa+uBZAOuhZV2B/tLwIqhf
         N4H3YfqpqAzoaPYFoUJK6VzYh4H2CRG1Z6j1g=
Subject: Re: [GIT PULL] perf fixes
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110523134125.GA23518@elte.hu>
References: <20110523134125.GA23518@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 00:10:48 +0200
Message-ID: <1306188648.2638.17.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 23 mai 2011 à 15:41 +0200, Ingo Molnar a écrit :
> Linus,
> 
> Please pull the latest perf-urgent-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-urgent-for-linus
> 
>  Thanks,
> 

Hi Ingo

I just tried latest "perf top" from linux-2.6 tree on my 32bit x86 host.

It outputs endless errors, I dont know if you guys already are aware of
this ?

Can't parse sample, err = -14
Can't parse sample, err = -14
Can't parse sample, err = -14
Can't parse sample, err = -14
Can't parse sample, err = -14
Can't parse sample, err = -14
Can't parse sample, err = -14
Can't parse sample, err = -14

Thanks


