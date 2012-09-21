Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2IUM5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:57:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:5408 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab2IUM5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:57:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,462,1344236400"; 
   d="scan'208";a="195760052"
Date: Fri, 21 Sep 2012 13:59:16 +0100
From: Alan Cox <alan@linux.intel.com>
To: Markus H <hauschild.markus@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: gma500_gfx black screen
Message-ID: <20120921135916.796d970e@bob.linux.org.uk>
In-Reply-To: <CAC27Lhfn+o5OWQFs6kvkaheh5cX_6jFxtJadLa8csJcfVknJLQ@mail.gmail.com>
References: <CAC27Lhfn+o5OWQFs6kvkaheh5cX_6jFxtJadLa8csJcfVknJLQ@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.11; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I could not find any indication that this problem has been fixed yet
> in 3.6rc.

Should be fixed in the very latest 3.6-rc. I got a report from someone
else that I could duplicate and pin down exactly. It's made somewhat
more complicated by the fact that another bug got introduced and then
fixed across the same period.

> I have to use a USB to serial converter as the tablet has no serial
> port. I can't get a serial console at all with the Ubuntu stock kernel
> probably because the pl2303 driver is not built into the kernel but
> rather loaded as module.

Correct

> 1. What other debugging options do I have so I can help with fixing
> the gma500_gfx driver.
> 2. Are there any single commits I could try on top of e.g. a stock
> 3.2.x kernel to see which one caused this regression?

Can you try the latest 3.6-rc release. The commit in question is
"gma500: Fix regression on Oaktrail devices"

