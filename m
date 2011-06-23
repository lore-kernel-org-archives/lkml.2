Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512Ab1FWOew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:34:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53205 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758901Ab1FWOev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:34:51 -0400
Date: Thu, 23 Jun 2011 16:34:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: ling.ma@intel.com
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC V2] [x86] Optimize copy-page by reducing impact from
 HW prefetch
Message-ID: <20110623143442.GA14680@elte.hu>
References: <1308353053-1928-1-git-send-email-ling.ma@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308353053-1928-1-git-send-email-ling.ma@intel.com>
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


* ling.ma@intel.com <ling.ma@intel.com> wrote:

> ---
>  arch/x86/lib/copy_page_64.S |  124 +++++++++++++++++++-----------------------
>  1 files changed, 56 insertions(+), 68 deletions(-)

What happened to the 2 patches suggestion i made in my mail:

> and do this cleanup patch first and the speedup on top of it, and
> keep the two in two separate patches so that the modification to the
> assembly code can be reviewed more easily.

?

Thanks,

	Ingo
