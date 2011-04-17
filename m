Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab1DQNzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 09:55:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56898 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab1DQNwy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 09:52:54 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Len Brown" <len.brown@intel.com>, "Pascal Dormeau" <pdormeau@free.fr>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
References: <sam8u5dLkaB.A.afE.53uqNB@chimera>
In-Reply-To: <sam8u5dLkaB.A.afE.53uqNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <IqJL5EkbqD.A.z9E.W4uqNB@chimera>
Subject: [Bug #31872] boot panic unless acpi=off, Thread overran stack, or stack corrupted - Toshiba Satellite/mobile P4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 17 Apr 2011 15:52:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.37 and 2.6.38.

The following bug entry is on the current list of known regressions
introduced between 2.6.37 and 2.6.38.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31872
Subject		: boot panic unless acpi=off, Thread overran stack, or stack corrupted - Toshiba Satellite/mobile P4
Submitter	: Pascal Dormeau <pdormeau@free.fr>
Date		: 2011-03-25 20:17 (24 days old)


