Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1IWUD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:03:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:39109 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab1IWUD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:03:28 -0400
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 23 Sep 2011 22:03:01 +0200
In-Reply-To: <1316804080-6396-1-git-send-email-venki@google.com>
References: <1316804080-6396-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316808181.9084.49.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 11:54 -0700, Venkatesh Pallipadi wrote:
> Comments?

Looks to be a possible IRQ latency issue as well, that can be a lot of
timers to run..
