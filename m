Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab0CYPDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:03:18 -0400
Received: from mail.df.lth.se ([194.47.250.12]:41345 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751180Ab0CYPDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:03:17 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 0/2] DMAENGINE: generic slave, generic status
Date: Thu, 25 Mar 2010 16:01:59 +0100
Message-Id: <1269529319-16369-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set will enable generic functions for controlling
slave transfers, e.g. the ability to pause and resume transfers,
as well as the ability to read a wider status including not only
the current and last transfer cookie but also the residual
bytes left on a channel.

This was discussed by Dan and Guennadi some while back and now
I implemented it.

I did my best to read my own code over and over again so I
didn't break anything, but please review again.

I need help: does someone have a list of defconfigs I need to
compile to compile-check the entire DMA engine subsystem?
I guess I will need a number of cross compilers as well, this
is a bit hairy but will probably help out in future refactoring
as well if I can get them to fly.

Linus Walleij
