Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1FVHDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 03:03:24 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:46799 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab1FVHDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 03:03:23 -0400
X-ASG-Debug-ID: 1308726201-01de280c1e729f0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E0193B5.3090406@fusionio.com>
Date: Wed, 22 Jun 2011 09:03:17 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 3/3] block: Break long IRQ disabled region
References: <20110621233444.094372367@chello.nl> <20110621233648.914681513@chello.nl>
X-ASG-Orig-Subj: Re: [RFC][PATCH 3/3] block: Break long IRQ disabled region
In-Reply-To: <20110621233648.914681513@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1308726201
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.66772
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-22 01:34, Peter Zijlstra wrote:
> Keeping IRQs disabled for long is not a feature.

This change looks fine to me. What kind of irq-off times did you see?

-- 
Jens Axboe

