Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280Ab2JYAJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:09:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35481 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab2JYAJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:09:38 -0400
MIME-Version: 1.0
In-Reply-To: <1351123698.8467.28.camel@gandalf.local.home>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
 <1351115634-8420-2-git-send-email-juri.lelli@gmail.com> <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
 <1351123698.8467.28.camel@gandalf.local.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Oct 2012 17:09:16 -0700
X-Google-Sender-Auth: GRD0z-wH_LjUyh7t4KI3ViUirII
Message-ID: <CA+55aFwERdk6PaKPe0PMSa_muuRVQqv6u-dc3zZitHn+wgbXMA@mail.gmail.com>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 5:08 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I'm assuming you meant the last include to be:
>
>   #include <linux/generic32bit-128bit.h>

That's a safe assumption.

> Cut and paste should be a federal crime.

We'd all be serving some hard time, I'm afraid.

         Linus
