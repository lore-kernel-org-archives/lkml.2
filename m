Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1EDNXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:23:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52501 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab1EDNXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:23:03 -0400
Date: Wed, 4 May 2011 15:22:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504132249.GB9978@elte.hu>
References: <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
 <20110503190822.GA20520@elte.hu>
 <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu>
 <alpine.LFD.2.02.1105041124080.3005@ionos>
 <20110504101932.GA3392@elte.hu>
 <alpine.LFD.2.02.1105041233280.3005@ionos>
 <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org>
 <alpine.LFD.2.02.1105041417330.3005@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105041417330.3005@ionos>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Which makes me even wonder some more whether we need that whole
> CMPXCHG_LOCAL #ifdeffery in slub.c at all.

I always found that #ifdeffery rather repulsive.

Thanks,

	Ingo
