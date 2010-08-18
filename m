Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0HRWDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 18:03:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52598 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab0HRWDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 18:03:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Luis Rodriguez <lrodriguez@atheros.com>, Tejun Heo <tj@kernel.org>
Subject: [Regression, 2.6.36-rc1] ath9k resume problem on Acer Ferrari One
Date: Thu, 19 Aug 2010 00:01:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        Maciej Rutecki <maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008190001.11342.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While testing 2.6.36-rc1 (with a couple of fixes on top) I noticed that the ath9k
driver didn't work after resume from suspend to RAM.  An attempt to unload the
driver using rmmod caused the BUG_ON() in kernel/workqueue.c:2844 to trigger.

I wonder if that regression is a result of the recent workqueue changes?

Thanks,
Rafael
