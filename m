Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0ITSCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:02:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51125 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498Ab0ITSCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:02:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/2] PM: Wakeup sources and async suspend error path bug fix
Date: Mon, 20 Sep 2010 19:57:40 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009201957.40995.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches are ready to go into linux-next from my point of
view, so please let me know if there are any objections:

[1/2] - PM / Wakeup: Introduce wakeup source objects and event statistics (v3)

[2/2] - PM: Fix potential issue with failing asynchronous suspend

Thanks,
Rafael

