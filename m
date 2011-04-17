Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab1DQM6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 08:58:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56654 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1DQM5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 08:57:04 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Jamie Iles" <jamie.iles@picochip.com>,
        "Jamie Iles" <jamie@jamieiles.com>,
        "Mark Jackson" <mpfj-list@mimc.co.uk>
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera>
In-Reply-To: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <_H4l51C1wXN.A.tAC.rGuqNB@chimera>
Subject: [Bug #33092] [regression] 2.6.39-rc1 - Beagleboard usbnet broken
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 17 Apr 2011 14:57:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.38.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33092
Subject		: [regression] 2.6.39-rc1 - Beagleboard usbnet broken
Submitter	: Mark Jackson <mpfj-list@mimc.co.uk>
Date		: 2011-04-04 9:22 (14 days old)
First-Bad-Commit: http://git.kernel.org/linus/087809fce28f50098d9c3ef1a6865c722f23afd2
Message-ID	: <4D998DC9.3040109@mimc.co.uk>
References	: http://marc.info/?l=linux-kernel&m=130191386508831&w=2


