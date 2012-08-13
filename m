Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2HMWXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:23:22 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36940 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab2HMWS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:18:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/3] PM / Domains: Fixes related to cpuidle
Date: Tue, 14 Aug 2012 00:19:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
MIME-Version: 1.0
Message-Id: <201208140019.19288.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following three patches fix some relatively minor issues and add
a bit of new functionality related to the PM domains' support for cpuidle.

[1/3] - Fix names of cpuidle-related PM domain's functions and add kerneldoc
        comments describing them.
[2/3] - Make the cpuidle ladder governor use the "disabled" state flag.
[3/3] - Make it possible to use domain names for connecting cpuidle to and
        disconnecting it from a PM domain.

The patches are on top of the current linux-next branch of the linux-pm.git tree.

Thanks,
Rafael

