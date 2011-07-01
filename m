Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab1GAMkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:40:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60383 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302Ab1GAMkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:40:23 -0400
Date: Fri, 1 Jul 2011 14:40:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: ling.ma@intel.com
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/2 ] [x86] Modify comments and clean up code.
Message-ID: <20110701124014.GC12605@elte.hu>
References: <1309300570-789-1-git-send-email-ling.ma@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309300570-789-1-git-send-email-ling.ma@intel.com>
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

> From: Ma Ling <ling.ma@intel.com>
> 
> Modern CPU use fast-string instruction to accelerate copy performance,
> by combining data into 128bit, so we modify comments and code style.
> 
> Thanks
> Ling
> 
> ---
>  arch/x86/lib/copy_page_64.S |  124 +++++++++++++++++++++---------------------
>  1 files changed, 62 insertions(+), 62 deletions(-)

Looks good in principle but there's no SOB so i cannot apply it.

Thanks,

	Ingo
