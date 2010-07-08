Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab0GHPH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 11:07:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:49157 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab0GHPHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 11:07:24 -0400
Date: Thu, 8 Jul 2010 08:11:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm <akpm@linux-foundation.org>
Subject: Re: high power consumption in recent kernels
Message-ID: <20100708081108.43268bee@infradead.org>
In-Reply-To: <1278590303.1900.91.camel@laptop>
References: <20100706164539.GA14783@gamma.logic.tuwien.ac.at>
	<1278579992.1900.17.camel@laptop>
	<20100708045711.398d4e26@infradead.org>
	<1278590303.1900.91.camel@laptop>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> and for that matter, what is "[extra timer interrupt]", surely the
> timer hardware doesn't generate spurious interrupts?

extra timer interrupt are those cases where we see the hardware
interrupt fire, but we do not have software timers to account for them.
two cases this can happen
* a NO_HZ bug
* we are idle longer than the longest interval we can program the hw
  timer for. Without HPET this can happen.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
