Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab1DLGfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 02:35:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37538 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab1DLGfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 02:35:51 -0400
Date: Tue, 12 Apr 2011 08:35:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: jacob pan <jacob.jun.pan@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH v2] x86/mrst: correct pin to irq mapping
Message-ID: <20110412063538.GD31050@elte.hu>
References: <1302286980-21139-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <20110410060154.GA24684@elte.hu>
 <20110411094330.69c86910@jacob-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110411094330.69c86910@jacob-laptop>
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


* jacob pan <jacob.jun.pan@linux.intel.com> wrote:

> Without the patch, kernel will crash during boot on Moorestown since the 
> secondary CPU clockevent (apbt1) will fail to request irq#1, which does not 
> have ioapic chip in its irq_desc[] entry. So, I would think this is an urgent 
> bug fix for 39.

Ok, just for future reference, this information is like 10x more important than 
*any* of the other information you presented in various changelog versions of 
this patch! I do not have this hardware so i had no idea how severe the problem 
was in practice - whether it's cosmetic, performance related or stability 
related.

I'll push your urgent fix to Linus via tip:x86/urgent.

Thanks,

	Ingo
