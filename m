Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab1HPOQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:16:04 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:53618 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1HPOP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:15:58 -0400
Message-Id: <20110816141441.898339466@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 16 Aug 2011 16:14:41 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Pavel Machek <pavel@ucw.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [patch 0/1] [patch 0/1] include storage keys in hibernation image
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Version 2 of the storage key patch for hibernation on s390.
I've added the following changes as you requested:
1) moved the s390 specific code to arch/s390/kernel/suspend.c
2) introduced CONFIG_ARCH_SAVE_PAGE_KEYS and added a select to
   the main s390 Kconfig file
3) added the empty default functions to include/linux/suspend.h

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
