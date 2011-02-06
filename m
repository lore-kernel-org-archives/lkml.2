Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab1BFUJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:09:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48389 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab1BFUJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:09:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 0/2] PM: Do not create wakeup sysfs files for devices that cannot wake up (v3)
Date: Sun, 6 Feb 2011 21:06:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Greg KH <greg@kroah.com>
References: <201102061519.11360.rjw@sisk.pl>
In-Reply-To: <201102061519.11360.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102062106.29712.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The second patch changes the PM core to only create wakeup sysfs files for
devices that are wakeup-capable.  The first one modifies drivers/usb/core/hub.c
so that it doesn't call device_set_wakeup_capable() under a spinlock.

They contain changes addressing the latest comments.

Thanks,
Rafael

