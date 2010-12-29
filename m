Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0L2XRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:17:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40245 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab0L2XR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:17:27 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Ben Hutchings" <ben@decadent.org.uk>
References: <96DQe4a_2tH.A.4RE.497GNB@chimera>
In-Reply-To: <96DQe4a_2tH.A.4RE.497GNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sV7shrPOroO.A.CqE.K-7GNB@chimera>
Subject: [Bug #25442] ixp4xx defines FREQ macro; conflicts with gspca/ov519 driver
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 30 Dec 2010 00:07:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.36.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25442
Subject		: ixp4xx defines FREQ macro; conflicts with gspca/ov519 driver
Submitter	: Ben Hutchings <ben@decadent.org.uk>
Date		: 2010-12-22 02:02 (8 days old)
Handled-By	: Ben Hutchings <ben@decadent.org.uk>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=41252


