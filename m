Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab0KRX6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:58:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34970 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab0KRX6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:58:14 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Len Brown" <len.brown@intel.com>,
        "Maciej Rutecki" <maciej.rutecki@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
References: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
In-Reply-To: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ATV3yiK8i4C.A.aVD.ohb5MB@chimera>
Subject: [Bug #22932] [REGRESSION] [2.6.37-rc1] Fan noise after suspend to ram/disk
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 19 Nov 2010 00:42:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.36.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22932
Subject		: [REGRESSION] [2.6.37-rc1] Fan noise after suspend to ram/disk
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2010-11-04 16:06 (15 days old)
First-Bad-Commit: http://git.kernel.org/linus/3e384ee6c687cb397581ee8f9440fc8220cfac80
Message-ID	: <201011041706.59046.maciej.rutecki@gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128888684308982&w=2
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=37372


