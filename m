Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2GTSWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:22:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:36219 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2GTSWg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:22:36 -0400
Message-ID: <1342808550.2583.48.camel@twins>
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle
 workers
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-pm@vger.kernel.org
Date: Fri, 20 Jul 2012 20:22:30 +0200
In-Reply-To: <20120720175041.GI32763@google.com>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
	 <1342799311.2583.7.camel@twins> <20120720170255.GE32763@google.com>
	 <1342804877.2583.42.camel@twins> <20120720175041.GI32763@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 10:50 -0700, Tejun Heo wrote:
> Also, re-binding busy workers is easy.  The idle ones are difficult
> and we have to do that anyway for PM optimization.  What would be the
> benefit of not re-binding busy ones at the risk of continually
> transferring workers to another CPU given the right workload + CPU
> down/up patterns? 

I really think people who use hotplug at high frequencies are on drugs
and doing it wrong.


