Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab0ILSf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:35:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47129 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab0ILSeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:34:31 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Arno Schuring" <aelschuring@hotmail.com>
References: <EP3NUDNWMO.A.O0.rrRjMB@chimera>
In-Reply-To: <EP3NUDNWMO.A.O0.rrRjMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <0c5PAlgnPrH.A.LoB.IsRjMB@chimera>
Subject: [Bug #17321] i386 WARNING: at kernel/softirq.c:143 _local_bh_enable_ip+0x2f/0x7e
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 12 Sep 2010 20:14:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17321
Subject		: i386 WARNING: at kernel/softirq.c:143 _local_bh_enable_ip+0x2f/0x7e
Submitter	: Arno Schuring <aelschuring@hotmail.com>
Date		: 2010-08-27 20:04 (17 days old)
Message-ID	: <4C781A3A.4010707@hotmail.com>
References	: http://marc.info/?l=linux-kernel&m=128294076822387&w=2


