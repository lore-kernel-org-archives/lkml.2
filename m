Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502Ab0HDHdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:33:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45585 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab0HDHdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:33:39 -0400
Date: Wed, 4 Aug 2010 09:33:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Dave Airlie <airlied@gmail.com>,
        Iranna D Ankad <iranna.ankad@in.ibm.com>,
        Gary Hade <garyhade@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: oops in ioapic_write_entry
Message-ID: <20100804073324.GC28183@elte.hu>
References: <4C57C319.8070800@kernel.org>
 <m11vagw2fl.fsf@fess.ebiederm.org>
 <4C57CD9C.70602@kernel.org>
 <m1fwywoz0f.fsf@fess.ebiederm.org>
 <4C57DACF.1090503@kernel.org>
 <m17hk8oy5g.fsf@fess.ebiederm.org>
 <4C57E32A.9070401@kernel.org>
 <m18w4onebi.fsf@fess.ebiederm.org>
 <4C5871BC.4070007@kernel.org>
 <m1bp9jgyww.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bp9jgyww.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1098]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> This patch definitely does not solve Dave Airlie's problem.  That was 
> clearly caused by a (ACPI being disabled compared to the test case) and a 
> bad BIOS provided MP table with an invalid apic_id, and our attempt to 
> lookup the ioapic and failed.

The kernel should not crash obviously, so that's a bug that has to be 
addressed - or failing any timely resolution the original patch which 
introduced the regression [if it's a regression] needs to be reverted.

Thanks,

	Ingo
