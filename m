Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab0HTIzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:55:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:44940 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab0HTIzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:55:18 -0400
Subject: Re: [patch 1/3] sched: init rt_avg stat whenever rq comes online
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chris@frostnet.net" <chris@frostnet.net>,
        "debian00@aliceadsl.fr" <debian00@aliceadsl.fr>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jonathan.protzenko@gmail.com" <jonathan.protzenko@gmail.com>,
        "mans@mansr.com" <mans@mansr.com>,
        "psastudio@mail.ru" <psastudio@mail.ru>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "stephan.eicher@web.de" <stephan.eicher@web.de>,
        "sxxe@gmx.de" <sxxe@gmx.de>,
        "thomas@archlinux.org" <thomas@archlinux.org>,
        "venki@google.com" <venki@google.com>,
        "wonghow@gmail.com" <wonghow@gmail.com>,
        "stable@kernel.org" <stable@kernel.org>, tglx <tglx@linutronix.de>
In-Reply-To: <1282262618.2675.24.camel@sbsiddha-MOBL3.sc.intel.com>
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
	 <20100813193911.827207098@sbsiddha-MOBL3.sc.intel.com>
	 <1281944854.1926.948.camel@laptop>
	 <1281980179.2676.22.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1281986708.1926.1877.camel@laptop>  <1282035085.1926.2164.camel@laptop>
	 <1282177213.7801.17.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1282208006.1926.4517.camel@laptop>
	 <1282262618.2675.24.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 20 Aug 2010 10:54:36 +0200
Message-ID: <1282294476.2605.670.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 17:03 -0700, Suresh Siddha wrote:
> Thomas/Peter/Ingo: can you please pick this up if you have no other
> objections. Thanks. 

Looks good, will queue. Thanks Suresh!
