Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab0K2Sy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:54:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:33684 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0K2Sy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:54:28 -0500
Date: Mon, 29 Nov 2010 16:53:28 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Ming Lei <tom.leiming@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 0/2] perf/urgent fixes
Message-ID: <20101129185328.GD6790@ghostprotocols.net>
References: <1291053372-13592-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291053372-13592-1-git-send-email-acme@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ENOCOFFEE :-\ Sorry

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo


Em Mon, Nov 29, 2010 at 03:56:10PM -0200, Arnaldo Carvalho de Melo escreveu:
> *** BLURB HERE ***
> 
> Arnaldo Carvalho de Melo (1):
>   perf symbols: Fix kallsyms kernel/module map splitting
> 
> Ming Lei (1):
>   perf symbols: Figure out start address of kernel map from kallsyms
> 
>  tools/perf/util/symbol.c |   59 +++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 53 insertions(+), 6 deletions(-)
