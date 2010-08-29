Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab0H2Wwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 18:52:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55207 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab0H2WwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 18:52:24 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Arno Schuring" <aelschuring@hotmail.com>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
In-Reply-To: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4AUWBNzTkbD.A.GQH.qFueMB@chimera>
Subject: [Bug #17321] i386 WARNING: at kernel/softirq.c:143 _local_bh_enable_ip+0x2f/0x7e
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 30 Aug 2010 00:36:37 +0200 (CEST)
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
Date		: 2010-08-27 20:04 (3 days old)
Message-ID	: <4C781A3A.4010707@hotmail.com>
References	: http://marc.info/?l=linux-kernel&m=128294076822387&w=2


