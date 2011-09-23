Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1IWTzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 15:55:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:39014 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1IWTzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 15:55:47 -0400
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 23 Sep 2011 21:55:18 +0200
In-Reply-To: <1316804080-6396-1-git-send-email-venki@google.com>
References: <1316804080-6396-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316807718.9084.48.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 11:54 -0700, Venkatesh Pallipadi wrote:
> Comments?

One of the reasons we didn't do it before was added cost to
hrtimer_{add,del}, did you measure workloads that are heavy on  that?
