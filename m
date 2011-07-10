Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1GJL0h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:26:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42680 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867Ab1GJL01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:26:27 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Alex Zhavnerchik" <alex.vizor@gmail.com>
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera>
In-Reply-To: <AtAvQwe5sAK.A.loH.OlYGOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <gK_efVqs2fP.A.vQ.JmYGOB@chimera>
Subject: [Bug #37042] linux 3.0.0-rc2 libata-eh.c:4018 ata_scsi_port_error_handler+0x80/0x53d on s2disk
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jul 2011 12:58:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.38 and 2.6.39.

The following bug entry is on the current list of known regressions
introduced between 2.6.38 and 2.6.39.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37042
Subject		: linux 3.0.0-rc2 libata-eh.c:4018 ata_scsi_port_error_handler+0x80/0x53d on s2disk
Submitter	: Alex Zhavnerchik <alex.vizor@gmail.com>
Date		: 2011-06-09 08:22 (32 days old)


