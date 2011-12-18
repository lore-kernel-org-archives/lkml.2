Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab1LRXpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 18:45:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33812 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab1LRXpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 18:45:09 -0500
Date: Mon, 19 Dec 2011 00:43:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Block <bebl@mageta.org>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com, tglx@linutronix.de,
        suresh.b.siddha@intel.com, eranian@google.com, brgerst@gmail.com,
        robert.richter@amd.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111218234309.GA12958@elte.hu>
References: <20111216160757.GL665@escobedo.osrc.amd.com>
 <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com>
 <1324051943-21112-4-git-send-email-hans.rosenfeld@amd.com>
 <20111218080443.GB4144@elte.hu>
 <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Block <bebl@mageta.org> wrote:

> The threshold-interrupt is already integrated with patch 5 of 
> this patch-set.
> 
> Maybe I wrote the descriptions a little misleading. Sry for 
> that. :)

Okay, i stopped reading at the first patch that claimed that the 
threshold irq was not supported ;-)

So the question becomes, how well is it integrated: can
perf 'record -a + perf report', or 'perf top' use LWP,
to do system-wide precise [user-space] profiling and such?

Thanks,

	Ingo
