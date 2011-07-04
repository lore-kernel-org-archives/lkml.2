Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426Ab1GDQgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:36:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60804 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab1GDQgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:36:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110704163313.GB28042@ponder.secretlab.ca>
References: <1309159583-11339-1-git-send-email-bigeasy@linutronix.de>
 <1309159583-11339-2-git-send-email-bigeasy@linutronix.de> <20110704161914.GH29977@ponder.secretlab.ca>
 <4E11EA63.8010909@linutronix.de> <20110704163313.GB28042@ponder.secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 4 Jul 2011 10:35:48 -0600
X-Google-Sender-Auth: hO-hTIJVDbVSwzuhIV-oSC8pJJg
Message-ID: <CACxGe6vNEFUf4o0Q5fh+Z2KG5knjgSSyPCT_b49=BqTdd0nZfA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] gpio: Add a driver for Sodaville GPIO controller
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 4, 2011 at 10:33 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Jul 04, 2011 at 06:29:23PM +0200, Sebastian Andrzej Siewior wrote:
>> Grant Likely wrote:
>> >
>> >I tried to apply this, but it failed to build:
>> >
>> >/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c: In
>> >function ‘sdv_xlate’:
>> >/home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:106:15:
>> >error: ‘struct irq_domain’ has no member named ‘of_node’
>>
>> >I assume there is a missing #include, you can either send a fixup
>> >patch or a new version, your choice.
>>
>> I guess you have to ask the DT maintainer which merged the irq_domain
>> thingy to create a topic branch for you :)
>
> HAHAHA.  I didn't bother to go digging into why it didn't compile.
> I'll merge the branches and see how it goes.

Actually, no.  I've not finished irq_domain yet, and it is not queued
up for v3.1 (though I hope to be done with it this week).  I guess
this patch will have to sit on the sidelines for a bit.

g.
