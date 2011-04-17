Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1DQNzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 09:55:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56855 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab1DQNwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 09:52:23 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Hans de Bruin" <jmdebruin@xmsnet.nl>
References: <sam8u5dLkaB.A.afE.53uqNB@chimera>
In-Reply-To: <sam8u5dLkaB.A.afE.53uqNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <IqJL5EkbqD.A.MTF.r4uqNB@chimera>
Subject: [Bug #31322] 2.6.38-rc echo 3 > /proc/sys/vm/drop_caches repairs mplayer distortions
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 17 Apr 2011 15:52:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.37 and 2.6.38.

The following bug entry is on the current list of known regressions
introduced between 2.6.37 and 2.6.38.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31322
Subject		: 2.6.38-rc echo 3 > /proc/sys/vm/drop_caches repairs mplayer distortions
Submitter	: Hans de Bruin <jmdebruin@xmsnet.nl>
Date		: 2011-03-14 21:34 (35 days old)
Message-ID	: <4D7E89E7.3080505@xmsnet.nl>
References	: http://marc.info/?l=linux-kernel&m=130014181919827&w=2


