Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0FSJAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 05:00:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45090 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab0FSJAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 05:00:33 -0400
Date: Sat, 19 Jun 2010 11:00:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Subject: Re: [PATCH 09/12] irq: implement IRQ expecting
Message-ID: <20100619090031.GE18946@basil.fritz.box>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
 <1276443098-20653-10-git-send-email-tj@kernel.org>
 <20100616204854.4b036f87@infradead.org>
 <87zkyro1xl.fsf@basil.nowhere.org>
 <4C1C830B.5020806@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1C830B.5020806@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IIUC, it's not to help or optimize polling itself.  It just gives us a
> way to estimate when the next interrupt would be so that power can be
> optimized for non polling cases.

Shouldn't the idle governour estimate this already?

BTW I looked at something like this for networking. There was
one case where a network benchmark was impacted by deep sleep
states while processing packets. But in the end it turned
out to be mostly a broken BIOS that gave wrong
parameters to the idle governour.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
