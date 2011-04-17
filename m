Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1DQNwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 09:52:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56826 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933Ab1DQNvh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 09:51:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "=?utf-8?q?Bj=C3=B6rn=20Schlie=C3=9Fmann?=" <chronoss@gmx.de>,
        "Chris Wilson" <chris@chris-wilson.co.uk>
References: <sam8u5dLkaB.A.afE.53uqNB@chimera>
In-Reply-To: <sam8u5dLkaB.A.afE.53uqNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <IqJL5EkbqD.A.TBG.P6uqNB@chimera>
Subject: [Bug #28802] commit 5d1d0cc breaks resume from suspend on Thinkpad X201
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 17 Apr 2011 15:52:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.37 and 2.6.38.

The following bug entry is on the current list of known regressions
introduced between 2.6.37 and 2.6.38.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28802
Subject		: commit 5d1d0cc breaks resume from suspend on Thinkpad X201
Submitter	: Björn Schließmann <chronoss@gmx.de>
Date		: 2011-02-10 17:23 (67 days old)
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>


