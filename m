Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1DQN4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 09:56:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56852 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab1DQNwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 09:52:22 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "De Ganseman Amaury" <amaury.deganseman@gmail.com>,
        "Shaohua Li" <shaohua.li@intel.com>
References: <sam8u5dLkaB.A.afE.53uqNB@chimera>
In-Reply-To: <sam8u5dLkaB.A.afE.53uqNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <IqJL5EkbqD.A.csF.U5uqNB@chimera>
Subject: [Bug #29992] boot hang 2.6.37.1 regression w/ intel_idle and CONFIG_NO_HZ=n - asus p7p55d le
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 17 Apr 2011 15:52:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.37 and 2.6.38.

The following bug entry is on the current list of known regressions
introduced between 2.6.37 and 2.6.38.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29992
Subject		: boot hang 2.6.37.1 regression w/ intel_idle and CONFIG_NO_HZ=n - asus p7p55d le
Submitter	: De Ganseman Amaury <amaury.deganseman@gmail.com>
Date		: 2011-02-27 10:38 (50 days old)


