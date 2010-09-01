Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab0IAQw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 12:52:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58104 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab0IAQw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 12:52:26 -0400
Date: Wed, 1 Sep 2010 18:52:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Robert Richter <robert.richter@amd.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH next&mainline] oprofile: fix build when CONFIG_PM is
 disabled
Message-ID: <20100901165211.GA22093@elte.hu>
References: <20100901133614.2580f238.sfr@canb.auug.org.au>
 <20100901094132.e734ad94.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901094132.e734ad94.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2484]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Using do/while for a function-returning-a-value does not
> make gcc happy, so change it to a static inline function.
> (happens when CONFIG_PM is not enabled)
> 
> arch/x86/oprofile/nmi_int.c:784: error: expected expression before 'do'

Yeah, i reported this to Robert a few hours ago, with the same suggested 
solution.

Thanks,

	Ingo
