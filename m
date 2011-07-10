Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab1GJL07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:26:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42706 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab1GJL05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:26:57 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "leniviy" <basinilya@gmail.com>
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera>
In-Reply-To: <AtAvQwe5sAK.A.loH.OlYGOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <gK_efVqs2fP.A.iqH.VlYGOB@chimera>
Subject: [Bug #38842] panic in elv_completed_request on safe remove usb hard drive
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jul 2011 12:58:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.38 and 2.6.39.

The following bug entry is on the current list of known regressions
introduced between 2.6.38 and 2.6.39.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38842
Subject		: panic in elv_completed_request on safe remove usb hard drive
Submitter	: leniviy <basinilya@gmail.com>
Date		: 2011-07-06 09:20 (5 days old)


