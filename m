Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1BFTgb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:36:31 -0500
Received: from www.tglx.de ([62.245.132.106]:53760 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab1BFTga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:36:30 -0500
Message-Id: <20110206193440.279124802@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 19:36:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Subject: [patch 0/3] microblaze: Convert irq chip to new functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

that series converts the irq_chip to the new functions. I've included
the .end removal patch as well, as the following patches depend on it.

Can you please test ? Will you push this to Linus for .39 or do you
want it to go through my tree ?

Thanks,

	tglx



