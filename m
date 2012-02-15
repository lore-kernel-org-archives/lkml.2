Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab2BOWUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:20:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54453 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab2BOWUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:20:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/3] PM / Sleep: Wakeup sources concurrency fixes
Date: Wed, 15 Feb 2012 23:18:04 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202152318.04206.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are a few synchronization problems spotted by Arve in the
wakeup sources core code and the following patches are supposed to fix
them.

[1/3] - Fix possible infinite loop during wakeup source destruction.
[2/3] - Fix race conditions related to wakeup source timer function.
[3/3] - Make __pm_stay_awake() delete wakeup source timers.

The details are in the changelogs.

The patches are on top of the pm-sleep branch of the linux-pm tree.

Please let me know if you see any problems with these patches.
Otherwise they are regarded as v3.4 material.

Thanks,
Rafael
