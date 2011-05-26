Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab1EZQ24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:28:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:35724 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab1EZQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:28:55 -0400
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Yong Zhang <yong.zhang0@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1306426823.27474.241.camel@e102391-lin.cambridge.arm.com>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
	 <1306272750.2497.79.camel@laptop> <1306343335.21578.65.camel@twins>
	 <1306358128.21578.107.camel@twins>
	 <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
	 <1306405979.1200.63.camel@twins>
	 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
	 <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins>
	 <20110526154508.GA13788@redhat.com>  <1306425584.2497.81.camel@laptop>
	 <1306426148.2497.83.camel@laptop>
	 <1306426823.27474.241.camel@e102391-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 18:32:17 +0200
Message-ID: <1306427537.2497.86.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 17:20 +0100, Marc Zyngier wrote:
> 
> Doesn't look very good here. The serial console basically locks up as
> soon as the system gets busy, even if the kernel compilation seem to
> progress at a decent pace. 


OK, I'll leave the one that worked queued up for this release. If we can
come up with a better alternative we can try for the next release, that
should give us ample time to test things and get us a working kernel
now ;-)

