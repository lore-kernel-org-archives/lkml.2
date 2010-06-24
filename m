Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab0FXNq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:46:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37804 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342Ab0FXNq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:46:28 -0400
Date: Thu, 24 Jun 2010 15:46:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <peterz@infradead.org>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org,
       mauro@elte.hu
Subject: Re: [RFC][PATCH] irq_work
Message-ID: <20100624134609.GB30323@elte.hu>
References: <20100624105254.GB578@basil.fritz.box>
 <1277377121.1875.948.camel@laptop>
 <20100624110830.GC578@basil.fritz.box>
 <1277377852.1875.950.camel@laptop>
 <20100624112340.GA13502@elte.hu>
 <1277379294.1875.959.camel@laptop>
 <20100624123537.GA28884@elte.hu>
 <20100624130234.GM578@basil.fritz.box>
 <20100624132032.GA4474@kryptos.osrc.amd.com>
 <20100624133323.GN578@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624133323.GN578@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3656]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > If its a critical error you do all the handling in the kernel and you
> 
> I assume you mean in MCE.  And the answer is no.
> 
> MCE generally can only panic or log, everything else
> needs other contexts.
> 
> > don't need task context at all, no? 
> 
> Process context is needed for various recovery schemes, all
> that need to sleep for example.

Please, as Peter and Boris asked you already, quote a concrete, specific 
example:

  'Specific event X occurs, kernel wants/needs to do Y. This cannot be done
   via the suggested method due to Z.'

Your generic arguments look wrong (to the extent they are specified) and it 
makes it much easier and faster to address your points if you dont blur them 
by vagaries.

Thanks,

	Ingo
