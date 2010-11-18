Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab0KRTwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:52:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33779 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab0KRTwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:52:10 -0500
Date: Thu, 18 Nov 2010 20:51:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [build failure] Re: BKL: remove extraneous #include <smp_lock.h>
Message-ID: <20101118195159.GA16050@elte.hu>
References: <201011172159.oAHLx1tu001236@hera.kernel.org>
 <20101117140526.d532b373.randy.dunlap@oracle.com>
 <AANLkTimO6CN9wOQco_1bqRmwBS7KfWW1CvumKFuiOWGH@mail.gmail.com>
 <20101118094342.GA10382@elte.hu>
 <AANLkTi=Xoo90jiaQBMxchFkKXt0dgre0tWe-LnVR6aSD@mail.gmail.com>
 <AANLkTikV+KVmwKg4jS2KPG+9EFdd9qD-VUak4qOgFgr4@mail.gmail.com>
 <20101118190205.GB10827@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118190205.GB10827@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> I guess it will all go away with CONFIG_BKL so we dont really care so deeply. I'll 
> test it.

Works fine here in various tests.

Tested-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
