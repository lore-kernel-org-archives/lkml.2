Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2HNVgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:36:07 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39001 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab2HNVgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:36:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/3] PM / Runtime: rpm_suspend() and rpm_resume() fixes
Date: Tue, 14 Aug 2012 23:34:45 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208142334.45452.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following three patches fix minor issues in rpm_suspend() and rpm_resume().
They are on top of the current linux-next branch of the linux-pm.git tree, but
they should apply to the mainline too.

[1/3] - Fix rpm_resume() return value for power.no_callbacks set and active
        parent.
[2/3] - Move the clearing of power.deferred_resume in rpm_suspend() to a better
        place.
[3/3] - Check the PM QoS setting before doing the first power.no_callbacks check.

Thanks,
Rafael

