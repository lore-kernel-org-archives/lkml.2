Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab1BUWNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 17:13:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45046 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab1BUWJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 17:09:42 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "=?utf-8?q?Jind=C5=99ich=20Makovi=C4=8Dka?=" <makovick@gmail.com>
References: <xmAo3o4v0VF.A.eLH.HWtYNB@chimera>
In-Reply-To: <xmAo3o4v0VF.A.eLH.HWtYNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5HY1m9_-mkI.A.c_H.GXtYNB@chimera>
Subject: [Bug #28432] khugepaged: gets stuck when writing to USB flash, 2.6.38-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Feb 2011 23:03:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.37.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28432
Subject		: khugepaged: gets stuck when writing to USB flash, 2.6.38-rc2
Submitter	: Jindřich Makovička <makovick@gmail.com>
Date		: 2011-01-31 19:28 (22 days old)
Message-ID	: <AANLkTi=uOpN0PwWdGh6iri-vJwuMS+WMPxmaZjv0-TrV@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129650210516627&w=2


