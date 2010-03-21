Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0CUUpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:45:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59228 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab0CUUnf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:43:35 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Daniel Vetter" <daniel@ffwll.ch>
References: <M9dVcHY7TxH.A.2GC.ZBopLB@chimera>
In-Reply-To: <M9dVcHY7TxH.A.2GC.ZBopLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <3Qs6IGJaRe.A.BzC.CCopLB@chimera>
Subject: [Bug #15518] CONFIG_NO_BOOTMEM=y breaks boot on 32bit
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Mar 2010 21:13:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15518
Subject		: CONFIG_NO_BOOTMEM=y breaks boot on 32bit
Submitter	: Daniel Vetter <daniel@ffwll.ch>
Date		: 2010-03-11 15:37 (11 days old)


