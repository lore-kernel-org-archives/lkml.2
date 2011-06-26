Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab1FZVtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 17:49:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59392 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab1FZVr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 17:47:27 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Jens Axboe" <jaxboe@fusionio.com>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera>
In-Reply-To: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <XWjMN7gBoXK.A.ULD.cZ6BOB@chimera>
Subject: [Bug #38122] 3.0-rc3 WARNING: at drivers/gpu/drm/i915/i915_drv.c:340 gen6_gt_force_wake_put+0x29/0x52 [i915]()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jun 2011 23:23:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.39.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38122
Subject		: 3.0-rc3 WARNING: at drivers/gpu/drm/i915/i915_drv.c:340 gen6_gt_force_wake_put+0x29/0x52 [i915]()
Submitter	: Jens Axboe <jaxboe@fusionio.com>
Date		: 2011-06-14 12:12 (13 days old)
Message-ID	: <<4DE3E2C9.6060207@fusionio.com>>
References	: http://marc.info/?l=linux-kernel&m=130805412314680&w=2
		  https://lkml.org/lkml/2011/5/30/261


