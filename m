Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab0EIWEF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 18:04:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33273 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab0EIWEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 18:04:00 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Hartley Sweeten" <hsweeten@visionengravers.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
References: <10aqDnTJcLO.A.mLE.48y5LB@chimera>
In-Reply-To: <10aqDnTJcLO.A.mLE.48y5LB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <HqroMXsT-CJ.A.YTF.R-y5LB@chimera>
Subject: [Bug #15729] BUG: physmap modprobe & rmmod
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 May 2010 23:17:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15729
Subject		: BUG: physmap modprobe & rmmod
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2010-04-02 20:40 (38 days old)
Message-ID	: <20100402134058.c4682716.randy.dunlap@oracle.com>
References	: http://marc.info/?l=linux-kernel&m=127024096210230&w=2
Handled-By	: Hartley Sweeten <hsweeten@visionengravers.com>
Patch		: https://patchwork.kernel.org/patch/90497/


