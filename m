Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab0FSTtk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 15:49:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54999 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab0FSTtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 15:49:39 -0400
Date: Sat, 19 Jun 2010 21:49:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>, mingo@elte.hu,
       tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Subject: Re: [PATCH 09/12] irq: implement IRQ expecting
Message-ID: <20100619194937.GR18946@basil.fritz.box>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
 <1276443098-20653-10-git-send-email-tj@kernel.org>
 <20100616204854.4b036f87@infradead.org>
 <87zkyro1xl.fsf@basil.nowhere.org>
 <4C1C830B.5020806@kernel.org>
 <20100619090031.GE18946@basil.fritz.box>
 <20100619075451.48c13589@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100619075451.48c13589@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here we have the opportunity to get real good information.. we KNOW
> now an interrupt is coming, and we can even estimate how long it'll
> be...  Even for the first few after a long time, before a pattern
> emerges.

Ok but I thought the driver would just fill in a single number 
likely. Is that really that good information?

Alternatively each driver would need to implement some dynamic
estimation algorithm, but that would be just mostly equivalent
to having it all in the idle governour?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
