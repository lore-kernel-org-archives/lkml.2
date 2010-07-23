Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab0GWLvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:51:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51643 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758420Ab0GWLvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:51:36 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Johannes Hirte" <johannes.hirte@fem.tu-ilmenau.de>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
In-Reply-To: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <tneGvaw1wLL.A.Ij.12XSMB@chimera>
Subject: [Bug #16365] kernel BUG at fs/btrfs/extent-tree.c:1353
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 23 Jul 2010 13:47:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16365
Subject		: kernel BUG at fs/btrfs/extent-tree.c:1353
Submitter	: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Date		: 2010-07-08 14:27 (16 days old)
Message-ID	: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de>
References	: http://marc.info/?l=linux-kernel&m=127859960725931&w=2


