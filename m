Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab0IXBVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 21:21:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:60791 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab0IXBVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 21:21:07 -0400
Subject: Re: [PATCH 1/8] posix clocks: introduce a syscall for clock tuning.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Rodolfo Giometti <giometti@linux.it>,
        Peter Zijlstra <peterz@infradead.org>, linux-api@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, linuxppc-dev@lists.ozlabs.org,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>
In-Reply-To: <alpine.LFD.2.00.1009240008390.2416@localhost6.localdomain6>
References: <cover.1285261533.git.richard.cochran@omicron.at>
	 <b94ef1cd9c04ef3ad5964408bd0af7251add78de.1285261534.git.richard.cochran@omicron.at>
	 <1285279423.5158.20.camel@pasglop>
	 <alpine.LFD.2.00.1009240008390.2416@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 11:20:04 +1000
Message-ID: <1285291204.14081.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-24 at 00:12 +0200, Thomas Gleixner wrote:
> > This list is getting way too much unrelated stuff, which I find
> > annoying, it would be nice if we were all a bit more careful here
> with
> > our CC lists.
> 
> Says the guy who missed to trim the useless context of the original
> mail, which made me scroll down all the way just to find out that
> there is nothing to see. 

Heh, you can usually ignore what's after my signature :-) At least I
didn't put my reply all the way down the bottom !

Cheers,
Ben.


