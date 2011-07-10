Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab1GJUrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:47:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43411 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120Ab1GJUrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:47:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH 0/2] PM / Domains: Add code for powering off all unused PM domains
Date: Sun, 10 Jul 2011 22:46:04 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, "Linux-SH" <linux-sh@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107102246.05107.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches are on top of the branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-domains

and the patchset I sent earlier today:

https://lkml.org/lkml/2011/7/10/27

and this patch: https://patchwork.kernel.org/patch/961202/

They introduce a mechanism allowing platforms to power off all of the PM
domains that don't contain devices in use in one shot.  The first patch
adds core support for that and the second one makes shmobile use it
instead of its own code.

Thanks,
Rafael

