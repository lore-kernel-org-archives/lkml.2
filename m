Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1EUKe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 06:34:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33522 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab1EUKeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 06:34:24 -0400
Date: Sat, 21 May 2011 12:34:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net
Subject: Re: [PATCH 1/2] perf stat: add -l <N> option to redirect stderr
 elsewhere
Message-ID: <20110521103418.GB23651@elte.hu>
References: <1305968203-14240-1-git-send-email-jim.cromie@gmail.com>
 <1305968203-14240-2-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305968203-14240-2-git-send-email-jim.cromie@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Jim Cromie <jim.cromie@gmail.com> wrote:

> This perf stat option emulates valgrind's --log-fd option, allowing the
> user to send perf results elsewhere, and leaving stderr for use by the
> program under test.
> 
>   3>results perf stat -l 3 -- <cmd>
> 
> The perl distro's make test.valgrind target uses valgrinds --log-fd
> option, I've adapted it to invoke perf also, and tested this patch there.
> 
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>

Makes sense!

Arnaldo, if you are fine with it, do you want to pick it up - or should i? If 
you pick it up:

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
