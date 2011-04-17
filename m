Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1DQM5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 08:57:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56651 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab1DQM5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 08:57:04 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Shaun Ruffell" <sruffell@digium.com>
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera>
In-Reply-To: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <_H4l51C1wXN.A.hSB.WGuqNB@chimera>
Subject: [Bug #33342] [2.6.39-rc2][bisected] Constant DISK_MEDIA_CHANGE_EVENTS from CDROM drive.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 17 Apr 2011 14:57:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.38.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33342
Subject		: [2.6.39-rc2][bisected] Constant DISK_MEDIA_CHANGE_EVENTS from CDROM drive.
Submitter	: Shaun Ruffell <sruffell@digium.com>
Date		: 2011-04-08 20:15 (10 days old)
Message-ID	: <20110408201513.GA3040@digium.com>
References	: http://marc.info/?l=linux-kernel&m=130229371907209&w=2


