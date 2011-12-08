Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab1LHK0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 05:26:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33300 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab1LHK0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 05:26:11 -0500
Date: Thu, 8 Dec 2011 11:24:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] kvm_tools: fix build fail
Message-ID: <20111208102424.GA30865@elte.hu>
References: <4EE07AE6.10804@cn.fujitsu.com>
 <1323334812.3904.8.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323334812.3904.8.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <levinsasha928@gmail.com> wrote:

> Hi Lai,
> 
> This was fixed in the KVM tools tree 2 days ago, but not 
> pulled into -tip yet.

Hm, i do daily pulls, sometimes more often - and this fix i 
pulled two days ago and pushed it out into -tip, because i was 
hit by it too.

Lai, are you using the right URI for -tip? The latest URI is:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

Thanks,

	Ingo
