Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1LHJms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:42:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:52348 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1LHJmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:42:43 -0500
Message-ID: <1323337318.17673.4.camel@twins>
Subject: Re: [patch v3 5/6] sched, ttwu_queue: queue remote wakeups only
 when crossing cache domains
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
Date: Thu, 08 Dec 2011 10:41:58 +0100
In-Reply-To: <1323324388.5118.16.camel@marge.simson.net>
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
	 <20111202010832.714874234@sbsiddha-desk.sc.intel.com>
	 <1322796864.4755.5.camel@marge.simson.net>
	 <1323275027.32012.114.camel@twins>
	 <1323285644.1984.55.camel@sbsiddha-desk.sc.intel.com>
	 <1323324388.5118.16.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 07:06 +0100, Mike Galbraith wrote:
> The stable regression fix should look about like so then, yes?

Something like that, yes.
