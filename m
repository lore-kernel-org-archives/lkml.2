Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2CMI1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:27:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37550 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab2CMI1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:27:14 -0400
Date: Tue, 13 Mar 2012 09:26:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avery Pennarun <apenwarr@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Fabio M. Di Nitto" <fdinitto@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Olaf Hering <olaf@aepfle.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/5] printk: use alloc_bootmem() instead of
 memblock_alloc().
Message-ID: <20120313082643.GA1888@elte.hu>
References: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
 <1331617001-20906-5-git-send-email-apenwarr@gmail.com>
 <CAE9FiQUakjaxE3fTm1w3SuuE-cAXAg2fePmEdwmjomAgp88Psg@mail.gmail.com>
 <CAHqTa-0b1DBDNYzDQ6UHHCivF9S-H3zvZWH0KZ21OQ8gQq6WYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHqTa-0b1DBDNYzDQ6UHHCivF9S-H3zvZWH0KZ21OQ8gQq6WYg@mail.gmail.com>
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


* Avery Pennarun <apenwarr@gmail.com> wrote:

> Hmm.  x86 uses nobootmem.c, [...]

For new code, we use memblock_reserve(), memblock_alloc(), et al.

Thanks,

	Ingo
