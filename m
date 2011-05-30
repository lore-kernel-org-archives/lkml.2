Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab1E3K6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:58:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39644 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819Ab1E3K6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:58:20 -0400
Date: Mon, 30 May 2011 12:58:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@MIT.EDU>
Cc: David Woodhouse <dwmw2@infradead.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110530105809.GA20133@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
 <20110530072300.GA9802@elte.hu>
 <1306745835.2029.389.camel@i7.infradead.org>
 <20110530104231.GF17821@elte.hu>
 <20110530104656.GA19532@elte.hu>
 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
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


* Theodore Tso <tytso@MIT.EDU> wrote:

> I'd think that "make ARCH=x86_64 oldconfig"
> 
> ... where the old configuration contained CONFIG_X86_32
> should trigger a warning, if not an outright error that 
> stops the build....

That would be a rather sad regression for me: i use that command 
regularly to transform .configs that came in bugreports into a config 
suitable for a testbox that has a different bitness userspace 
installed.

Thanks,

	Ingo
