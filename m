Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab0CUUnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:43:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59236 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520Ab0CUUnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:43:43 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Andrew Benton" <b3nton@gmail.com>, "Jeff Garzik" <jgarzik@pobox.com>
References: <M9dVcHY7TxH.A.2GC.ZBopLB@chimera>
In-Reply-To: <M9dVcHY7TxH.A.2GC.ZBopLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <3Qs6IGJaRe.A.RvC.xBopLB@chimera>
Subject: [Bug #15537] 2.6.34-rc1 hangs for 30 seconds when trying to access the disk
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Mar 2010 21:13:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15537
Subject		: 2.6.34-rc1 hangs for 30 seconds when trying to access the disk
Submitter	: Andrew Benton <b3nton@gmail.com>
Date		: 2010-03-14 23:26 (8 days old)
Handled-By	: Jeff Garzik <jgarzik@pobox.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=25516


