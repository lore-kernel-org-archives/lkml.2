Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab1E0JbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:31:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60828 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab1E0JbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:31:00 -0400
Date: Fri, 27 May 2011 11:30:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Mike Travis <travis@sgi.com>, David Woodhouse <dwmw2@infradead.org>,
        Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        iommu@lists.linux-foundation.org, Mike Habeck <habeck@sgi.com>,
        stable@kernel.org
Subject: Re: [stable] [PATCH 1/7] Intel pci: Check for identity mapping
 candidate using system dma mask
Message-ID: <20110527093042.GG21386@elte.hu>
References: <20110527013221.231071058@gulag1.americas.sgi.com>
 <20110527013221.405688800@gulag1.americas.sgi.com>
 <20110527071838.GA16217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527071838.GA16217@kroah.com>
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


* Greg KH <greg@kroah.com> wrote:

> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the 
> stable kernel tree.  Please read 
> Documentation/stable_kernel_rules.txt for how to do this properly.
> 
> </formletter>
> 
> I'll not send this out for the other 6 patches that also do not 
> follow the proper format, as I'm sure you would get bored reading 
> them.

None of these patches exist upstream yet so it will take some time 
until any of this can touch -stable. You can ignore it safely for 
now.

Mike: please add proposed stable Cc: tags in the patch only, never 
send it out to the stable email address itself!!

Thanks,

	Ingo
