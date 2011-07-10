Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab1GJLFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:05:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42433 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601Ab1GJLFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:05:08 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Ben Greear" <greearb@candelatech.com>
References: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera>
In-Reply-To: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <XNkIyhV6dgF.A.HBH.fCYGOB@chimera>
Subject: [Bug #38302] NFS crash in un-modified 3.0.0-rc3+, list corruption.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jul 2011 12:38:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.39.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38302
Subject		: NFS crash in un-modified 3.0.0-rc3+, list corruption.
Submitter	: Ben Greear <greearb@candelatech.com>
Date		: 2011-06-20 22:42 (21 days old)
Message-ID	: <4DFFCCDC.2070106@candelatech.com>
References	: http://marc.info/?l=linux-kernel&m=130860979610651&w=2
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=63902


