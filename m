Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1K0W5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 17:57:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58984 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab1K0W5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 17:57:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/2] PM / Sleep: Simplyfy device suspend/resume code paths
Date: Sun, 27 Nov 2011 23:57:26 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, "Greg Kroah-Hartman" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111272357.26930.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches reduce the size of the device suspend/resume code
in drivers/base/power/main.c and simplifies it.

[1/2] - Unify diagnostic messages from device suspend/resume
[2/2] - Remove pm_op() and pm_noirq_op()

Thanks,
Rafael

