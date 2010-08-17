Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750886Ab0HQUI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 16:08:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48973 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab0HQUIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 16:08:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.36-rc1: Doesn't boot on an AMD-based machine
Date: Tue, 17 Aug 2010 22:06:14 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008172206.14349.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The subject says it all, the last message printed is:

CPU0: AMD Athlon(tm) X2 Dual Core Processor L310 stepping 02

so I guess the AMD C1E detection is broken.

I'm going to identify the offending commit.

Thanks,
Rafael
