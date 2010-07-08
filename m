Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214Ab0GIAGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 20:06:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37879 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758950Ab0GHX6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:58:17 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Alex Chiang" <achiang@canonical.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Ryan Wang" <openspace.wang@gmail.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
In-Reply-To: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TXb9XdQzJoD.A.5eD.pNmNMB@chimera>
Subject: [Bug #16197] [BUG on 2.6.35-rc2] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:11.0/0000:02:03.0/slot'
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Jul 2010 01:41:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16197
Subject		: [BUG on 2.6.35-rc2] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:11.0/0000:02:03.0/slot'
Submitter	: Ryan Wang <openspace.wang@gmail.com>
Date		: 2010-06-07 0:23 (32 days old)
Message-ID	: <AANLkTincwMZPnYW3S4uz4k2GOn52RpgBIBRfzyD010Yo@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127587022219378&w=2


