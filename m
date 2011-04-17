Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1DQNz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 09:55:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56873 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab1DQNwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 09:52:31 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Pavel Kysilka" <goldenfish@linuxsoft.cz>
References: <sam8u5dLkaB.A.afE.53uqNB@chimera>
In-Reply-To: <sam8u5dLkaB.A.afE.53uqNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <IqJL5EkbqD.A.UDF.e4uqNB@chimera>
Subject: [Bug #31572] BUG in vb_alloc() - firewire crash at boot
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 17 Apr 2011 15:52:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.37 and 2.6.38.

The following bug entry is on the current list of known regressions
introduced between 2.6.37 and 2.6.38.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31572
Subject		: BUG in vb_alloc() - firewire crash at boot
Submitter	: Pavel Kysilka <goldenfish@linuxsoft.cz>
Date		: 2011-03-21 12:40 (28 days old)


