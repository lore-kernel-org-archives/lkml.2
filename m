Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab2JOFOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 01:14:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35619 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2JOFOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 01:14:54 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [RFC PATCH 0/3] mm/PM/USB: force memory allocation with no io in need
Date: Mon, 15 Oct 2012 13:14:16 +0800
Message-Id: <1350278059-14904-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set introduces one process flag and trys to fix one deadlock
problem on block device during runtime resume or usb bus reset.

The 1st one is the change on include/sched.h and mm/page_alloc.c.

The other 2 patches are applied again PM and USB subsystem to demo
how to use the introduced mechanism to fix the deadlock problem.

 drivers/base/power/runtime.c |   13 +++++++++++++
 drivers/usb/core/hub.c       |   42 +++++++++++++++++++++++++++++++++++++++++-
 drivers/usb/storage/uas.c    |    4 ++++
 drivers/usb/storage/usb.c    |    4 ++++
 include/linux/sched.h        |    5 +++++
 include/linux/usb.h          |    1 +
 mm/page_alloc.c              |    2 ++


Thanks,
--
Ming Lei

