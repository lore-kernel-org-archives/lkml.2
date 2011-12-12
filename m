Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab1LLSfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:35:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51562 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab1LLSfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:35:07 -0500
Date: Mon, 12 Dec 2011 19:33:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH -tip] x86: fix build without CONFIG_X86_MRST
Message-ID: <20111212183320.GA23744@elte.hu>
References: <1323166702-12990-1-git-send-email-sgruszka@redhat.com>
 <20111206103022.434ebf6f@lxorguk.ukuu.org.uk>
 <20111206103103.GC15966@elte.hu>
 <20111206131706.5491a5f2@lxorguk.ukuu.org.uk>
 <20111206171241.GA20816@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206171241.GA20816@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> Note that even with the latest fixes, there's a build failure 
> left in -tip:
> 
> (.text+0x2231b): undefined reference to `sfi_get_mtmr'
> (.text+0x2235a): undefined reference to `sfi_free_mtmr'
> (.text+0x22364): undefined reference to `sfi_get_mtmr'apb_timer.c:(.init.text+0xac57): undefined reference to 
> `mrst_timer_options'

Alan, any update on this? The build failures are still showing 
up rather frequently in my testing and they affect upstream as 
well.

This is with the latest round of fixes you did.

Thanks,

	Ingo
