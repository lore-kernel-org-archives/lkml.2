Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1HHWcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 18:32:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55700 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1HHWcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 18:32:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/4] PM: Make power.subsys_data be more useful
Date: Tue, 9 Aug 2011 00:28:12 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108090028.12698.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patchset reworks the power.subsys_data field of
struct device so that it can be used not only for clock PM
management.

[1/4] - Introduce struct pm_subsys_data to be point to by power.subsys_data.
[2/4] - Add reference counting for power.subsys_data.
[3/4] - Optimize generic PM domains code by making it use power.subsys_data.
[4/4] - Move PM clock management headers and definitions to a separate file.

The patchset is on top of the pm-domains branch of the linux-pm tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-domains

It has been tested on an ARM shmobile Mackerel board.

Thanks,
Rafael
