Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1HAQoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:44:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:44714 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab1HAQoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:44:08 -0400
Message-ID: <4E36D7D6.4010004@linutronix.de>
Date: Mon, 01 Aug 2011 18:44:06 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: sodaville@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [sodaville] [PATCH v2 2/2] gpio: Add a driver for Sodaville	GPIO
 controller
References: <1309159583-11339-1-git-send-email-bigeasy@linutronix.de>	<1309159583-11339-2-git-send-email-bigeasy@linutronix.de>	<20110704161914.GH29977@ponder.secretlab.ca>	<4E11EA63.8010909@linutronix.de>	<20110704163313.GB28042@ponder.secretlab.ca> <CACxGe6vNEFUf4o0Q5fh+Z2KG5knjgSSyPCT_b49=BqTdd0nZfA@mail.gmail.com>
In-Reply-To: <CACxGe6vNEFUf4o0Q5fh+Z2KG5knjgSSyPCT_b49=BqTdd0nZfA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
>> HAHAHA.  I didn't bother to go digging into why it didn't compile.
>> I'll merge the branches and see how it goes.
> 
> Actually, no.  I've not finished irq_domain yet, and it is not queued
> up for v3.1 (though I hope to be done with it this week).  I guess
> this patch will have to sit on the sidelines for a bit.

Since the domain_irq stuff is mainline now anyway to get this merged for
v3.1?

> 
> g.


Sebastian
