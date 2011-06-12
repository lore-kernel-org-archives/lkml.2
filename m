Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab1FLVap (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 17:30:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50107 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab1FLVal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 17:30:41 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Jean Delvare" <khali@linux-fr.org>, "Mark" <markotahal@gmail.com>
References: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera>
In-Reply-To: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <kTLfM29CaqB.A.zXF.f0S9NB@chimera>
Subject: [Bug #35572] eeprom module: modprobing hangs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 12 Jun 2011 23:12:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.38 and 2.6.39.

The following bug entry is on the current list of known regressions
introduced between 2.6.38 and 2.6.39.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=35572
Subject		: eeprom module: modprobing hangs
Submitter	: Mark <markotahal@gmail.com>
Date		: 2011-05-21 20:17 (23 days old)
Handled-By	: Jean Delvare <khali@linux-fr.org>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=60812


