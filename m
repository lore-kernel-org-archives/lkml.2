Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab1K0L65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 06:58:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58548 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab1K0L6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 06:58:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/5] PM: Documentation updates
Date: Sun, 27 Nov 2011 13:01:47 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>,
        Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111271301.47244.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches update the PM documenataion in the kernel tree to
follow the current code.

[1/5] - Document the use of PM domains by the PM core correctly.
[2/5] - Update system suspend/hibernation documentation to follow the code.
[3/5] - Update runtime PM documentation to follow the code.
[4/5] - Document the current core wakeup code correctly.
[5/5] - Make PM callbacks descriptions follow the code.

I'm considering these patches as 3.2 material if there are no objections.

Thanks,
Rafael
