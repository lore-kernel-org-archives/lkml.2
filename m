Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab1JUXJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 19:09:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54892 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab1JUXJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 19:09:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 0/2] PM: Generic PM domains and device PM QoS (v2)
Date: Sat, 22 Oct 2011 01:09:52 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        Magnus Damm <magnus.damm@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110220109.52991.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset is a refresh of patches introducing simple PM QoS governor
functions for PM domains.  The patches still haven't been tested properly,
although they should build.  The purpose of them is mainly to illustrate
how PM QoS may be used with PM domains to control device runtime PM.

Thanks,
Rafael

