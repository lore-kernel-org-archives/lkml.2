Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab1EFWcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:32:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56837 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab1EFWcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:32:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/3] PM / Hibernate: Fixes related to user space interface
Date: Sat, 7 May 2011 00:29:44 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alexandre Felipe Muller de Souza 
	<alexandrefm@mandriva.com.br>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105070029.44623.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following three patches fix bugs related to the hibernate user space
interface:

[1/3] - Fix warning from pm_restrict_gfp_mask() in the SNAPSHOT_S2RAM ioctl
        code path.

[2/3] - Make snapshot_release() call pm_restore_gfp_mask() if tasks weren't
        thawed before.

[3/3] - Make the SNAPSHOT_S2RAM clear data->ready.

With all of these patches applied, s2both actually works on my Toshiba test
machine, which is nice. :-)

Many thanks to Alexandre for turning my attention to these problems.

Thanks,
Rafael
