Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1FFQyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:54:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:55593 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab1FFQyE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:54:04 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Arne Jansen <lists@die-jansens.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <4DED0423.4050904@die-jansens.de>
References: <4DEB933C.1070900@die-jansens.de>
	 <20110605151323.GA30590@elte.hu> <1307349530.2353.7374.camel@twins>
	 <20110606145827.GD30348@elte.hu> <1307372989.2322.136.camel@twins>
	 <1307375227.2322.161.camel@twins> <20110606155236.GA7374@elte.hu>
	 <1307376039.2322.164.camel@twins> <20110606160810.GA16636@elte.hu>
	 <1307376771.2322.168.camel@twins> <20110606161749.GA22157@elte.hu>
	 <4DED0292.1040605@die-jansens.de>  <4DED0423.4050904@die-jansens.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 18:53:57 +0200
Message-ID: <1307379237.2322.203.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 18:45 +0200, Arne Jansen wrote:
> > As long as it doesn't scramble the order of the messages, the delay
> > imho doesn't matter even in very printk-heavy debugging sessions.
> 
> And, as important, doesn't reduce the throughput of printk. Having only
> 100 wakeups/s sounds like the throughput is limited to 100xsizeof(ring 
> buffer). 

Right, that's another problem.. not really sure delaying all this is
going to work :/


