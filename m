Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0INR5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:57:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59203 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab0INR5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:57:37 -0400
Date: Tue, 14 Sep 2010 19:57:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>, linux-kernel@vger.kernel.org,
        greg@kroah.com, x86@kernel.org
Subject: Re: [PATCH v3 1/4] x86, mrst: make mrst_identify_cpu() inlne inside
 mrst.h
Message-ID: <20100914175726.GD3822@elte.hu>
References: <1284361736-23011-1-git-send-email-feng.tang@intel.com>
 <1284361736-23011-2-git-send-email-feng.tang@intel.com>
 <20100914144345.49e05674@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914144345.49e05674@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@linux.intel.com> wrote:

> On Mon, 13 Sep 2010 15:08:53 +0800
> Feng Tang <feng.tang@intel.com> wrote:
> 
> > Otherwise there will be some compilation warning for those .c files 
> > which include mrst.h
> 
> I've sent this to Ingo four or five times already and been ignored.

I did a search of my mbox for all mails containing 'mrst_identify_cpu', 
and the one by Feng Tang sent yesterday is the only one - none from you. 
Searched the spam folder and the separate lkml folder too.

So where are those 4-5 emails, got any link perhaps?

Thanks,

	Ingo
