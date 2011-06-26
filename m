Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab1FZVrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 17:47:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59365 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab1FZVqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 17:46:53 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>,
        "Oliver Hartkopp" <socketcan@hartkopp.net>,
        "Yinghai Lu" <yinghai@kernel.org>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera>
In-Reply-To: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <XWjMN7gBoXK.A.pkD.yZ6BOB@chimera>
Subject: [Bug #37432] sdhci-pci fails on 3.0.0-rc1 on Dell E6510
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jun 2011 23:23:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.39.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37432
Subject		: sdhci-pci fails on 3.0.0-rc1 on Dell E6510
Submitter	: Oliver Hartkopp <socketcan@hartkopp.net>
Date		: 2011-06-07 20:06 (20 days old)
First-Bad-Commit: http://git.kernel.org/linus/da7822e5ad71ec9b745b412639f1e5e0ba795a20
References	: http://article.gmane.org/gmane.linux.kernel.mmc/8442


