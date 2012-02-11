Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab2BKNtI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 08:49:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43247 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab2BKNtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 08:49:07 -0500
Date: Sat, 11 Feb 2012 14:48:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jesper Krogh <jesper@krogh.cc>
Cc: linux-kernel@vger.kernel.org, jk@novozymes.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        herrmann.der.user@googlemail.com
Subject: Re: Memory issues with Opteron 6220
Message-ID: <20120211134847.GD28098@elte.hu>
References: <20120208143741.GB28486@otto.nzcorp.net>
 <20120209083315.GA19380@elte.hu>
 <4F343582.7080007@krogh.cc>
 <4F3535E7.4000007@krogh.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3535E7.4000007@krogh.cc>
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


* Jesper Krogh <jesper@krogh.cc> wrote:

> [...]
> 
> I would admit that we could have saved a significant of 
> time/fustration if dmesg had revealed a message that it was 
> the overcommit limits being hit and thus knocking off the 
> processes.

It would be helpful if you could enhance the printk in such a 
way, and if you tested it with your workload that triggers it - 
and send us the resulting patch. Having more information in the 
dmesg is never bad.

Thanks,

	Ingo
