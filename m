Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab0GWLvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:51:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51615 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104Ab0GWLu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:50:59 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Johannes Berg" <johannes@sipsolutions.net>,
        "Kay Sievers" <kay.sievers@vrfy.org>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
In-Reply-To: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <tneGvaw1wLL.A.U7B.O4XSMB@chimera>
Subject: [Bug #16257] sysfs changes break hwsim and bnep drivers
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 23 Jul 2010 13:47:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16257
Subject		: sysfs changes break hwsim and bnep drivers
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2010-06-20 11:23 (34 days old)
References	: http://thread.gmane.org/gmane.linux.network/162754
Handled-By	: Eric W. Biederman <ebiederm@xmission.com>
		  Kay Sievers <kay.sievers@vrfy.org>


