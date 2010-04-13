Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab0DMMaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 08:30:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:47016 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab0DMM3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 08:29:49 -0400
Subject: Re: [PATCH 2/5] sched: add asymmetric packing option for sibling
 domain
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <20100409062118.DDF38CBB6E@localhost.localdomain>
References: <20100409062118.DDF38CBB6E@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 13 Apr 2010 14:29:27 +0200
Message-ID: <1271161767.4807.1281.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 16:21 +1000, Michael Neuling wrote:
> Peter: Since this is based mainly off your initial patch, it should
> have your signed-off-by too, but I didn't want to add without your
> permission.  Can I add it?

Of course! :-)

This thing does need a better changelog though, and maybe a larger
comment with check_asym_packing(), explaining why and what we're doing
and what we're assuming (that lower cpu number also means lower thread
number).
