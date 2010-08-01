Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0HAN7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 09:59:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52666 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757251Ab0HAN7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 09:59:24 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "caiqian@redhat.com"@ogre.sisk.pl
References: <2dWFdr9kTFM.A.P0D.spXVMB@chimera>
In-Reply-To: <2dWFdr9kTFM.A.P0D.spXVMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Aan7wZ97YaE.A.4_D.-pXVMB@chimera>
Subject: [Bug #16448] 2.6.35-rc5 panic at __br_deliver+0x64/0xe0 with kvm bridge networking
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  1 Aug 2010 15:52:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16448
Subject		: 2.6.35-rc5 panic at __br_deliver+0x64/0xe0 with kvm bridge networking
Submitter	: caiqian@redhat.com
Date		: 2010-07-23 3:25 (10 days old)
Message-ID	: <198123598.1050221279855515402.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
References	: http://marc.info/?l=linux-kernel&m=127985553916052&w=2


