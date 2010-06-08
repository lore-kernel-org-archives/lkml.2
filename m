Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0FHRo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:44:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58318 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732Ab0FHRo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:44:57 -0400
Date: Tue, 8 Jun 2010 19:44:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Michal Marek <mmarek@suse.cz>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/4] Perf improvements for .36 (perf/core)
Message-ID: <20100608174424.GF11585@elte.hu>
References: <1275511215-25703-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275511215-25703-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0406]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Hi Ingo,
> 
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> 	I'll keep perf/urgent for .35 stuff, perf/core now has only things
> for .36 and I'm merging perf/urgent into perf/core when you pull from it.

Yeah, that sounds good! Fixes then propagate into perf/core in due course via 
an -rcx back-merge (or earlier, if they cause conflicts and need to be merged).

> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (1):
>   perf tools: Make target to generate self contained source tarball
> 
> Stephane Eranian (3):
>   perf report: Make -D print sampled CPU
>   perf tools: Add the ability to specify list of cpus to monitor
>   perf buildid: add perfconfig option to specify buildid cache dir

Pulled, thanks Arnaldo!

	Ingo
