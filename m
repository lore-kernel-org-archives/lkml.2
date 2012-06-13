Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2FMNjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:39:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61541 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab2FMNjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:39:01 -0400
Date: Wed, 13 Jun 2012 15:38:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] irq/core changes for v3.5
Message-ID: <20120613133855.GA32428@gmail.com>
References: <20120522032554.GA11358@gmail.com>
 <Pine.LNX.4.64.1206121201130.6800@axis700.grange>
 <alpine.LFD.2.02.1206121639420.3086@ionos>
 <CA+55aFxNy2-DnWVDUiOuF+NncRBUC=frZN+CTLsJ+o2ofXtZYQ@mail.gmail.com>
 <alpine.LFD.2.02.1206121732230.3086@ionos>
 <CA+55aFxC0436vCDwX8nUnKNa3ZZi=ZhL0w6eMk0hM3oKTz4LJw@mail.gmail.com>
 <alpine.LFD.2.02.1206131127050.3086@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1206131127050.3086@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> A 5th option would be to emit a warning in case the flag is 
> not set, fix it up for now and schedule it for removal in 3.6. 
> Anything what's not fixed by then is broken for good.

Seems like the least invasive option to me. It's not like we are 
in a rush to break more stuff.

Thanks,

	Ingo
