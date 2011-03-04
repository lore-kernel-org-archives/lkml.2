Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520Ab1CDMDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 07:03:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52143 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab1CDMDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 07:03:33 -0500
Date: Fri, 4 Mar 2011 13:03:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, gorcunov@gmail.com
Subject: Re: [PATCHv2 1/7] x86: remove superflous goal definition of tsc_sync
Message-ID: <20110304120321.GD25703@elte.hu>
References: <1299239923-7092-1-git-send-email-henne@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299239923-7092-1-git-send-email-henne@nachtwindheim.de>
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


* Henrik Kretzschmar <henne@nachtwindheim.de> wrote:

> This goal definition is superflous.
> CONFIG_X86_64_SMP depends on CONFIG_SMP
> and tsc_sync.o is already in the definition of CONFIG_SMP.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

Please pick up the Acked-by's you got for the patches from Cyrill and repost the 
series once all patches are acked.

Thanks,

	Ingo
