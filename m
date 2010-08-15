Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab0HORcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 13:32:08 -0400
Received: from xenotime.net ([72.52.115.56]:43645 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932406Ab0HORcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 13:32:07 -0400
Date: Sun, 15 Aug 2010 10:31:56 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ernst Schwab <eschwab@online.de>, spi-devel-general@lists.sourceforge.net,
        lkml <linux-kernel@vger.kernel.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: spi.h: missing kernel-doc notation, please fix
Message-Id: <20100815103156.37ae14cd.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ernst,

This patch in mainline:

commit cf32b71e981ca63e8f349d8585ca2a3583b556e0
Author: Ernst Schwab <eschwab@online.de>
Date:   Mon Jun 28 17:49:29 2010 -0700

    spi/mmc_spi: SPI bus locking API, using mutex

adds some struct fields but does not add kernel-doc notation for them.
Please add that missing struct documentation.

Warning(include/linux/spi/spi.h:304): No description found for parameter 'bus_lock_spinlock'
Warning(include/linux/spi/spi.h:304): No description found for parameter 'bus_lock_mutex'
Warning(include/linux/spi/spi.h:304): No description found for parameter 'bus_lock_flag'

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
