Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442Ab1ENWj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 18:39:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51810 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755596Ab1ENWiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 18:38:52 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        "David Woodhouse" <David.Woodhouse@intel.com>,
        "Donald Dutile" <ddutile@redhat.com>, "" <optiluca@gmail.com>
References: <So1vU2GC7XM.A.5wB.44vzNB@chimera>
In-Reply-To: <So1vU2GC7XM.A.5wB.44vzNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <HA8urZ3ZRcP.A.B4B.94vzNB@chimera>
Subject: [Bug #35062] Suspend to ram stopped working after commit of " intel-iommu: Unlink domain from iommu "
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 15 May 2011 00:30:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.38.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=35062
Subject		: Suspend to ram stopped working after commit of " intel-iommu: Unlink domain from iommu "
Submitter	:  <optiluca@gmail.com>
Date		: 2011-05-14 11:08 (1 days old)
First-Bad-Commit: http://git.kernel.org/linus/a97590e56d0d58e1dd262353f7cbd84e81d8e600


