Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab1CNMkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:40:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43970 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab1CNMkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:40:00 -0400
Date: Mon, 14 Mar 2011 13:39:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: hpa@zytor.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, tlb: small cleanup for native_flush_tlb_others
Message-ID: <20110314123956.GA28442@elte.hu>
References: <4D7DBBE3.1010104@cn.fujitsu.com>
 <20110314123355.GA27477@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314123355.GA27477@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Also, the title of the patch should be something like 'small micro-optimization' - 
as it's not just a cleanup, it has side-effects on the code.

Thanks,

	Ingo
