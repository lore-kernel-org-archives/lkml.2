Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab1KVQRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:17:10 -0500
Received: from xyratex197.xyratex.com ([194.131.166.197]:56481 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757646Ab1KVQRI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:17:08 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] [SCSI] aacraid: Use kmemdup rather than duplicating its implementation
Date: Tue, 22 Nov 2011 08:17:03 -0800
Message-ID: <FC1F9E38C0703341A1A750524E2525A901978CDE@XYUS-EX22.xyus.xyratex.com>
In-Reply-To: <1321977410.1131.24.camel@Joe-Laptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [SCSI] aacraid: Use kmemdup rather than duplicating its implementation
Thread-Index: AcypL4RgGkGfXoAEQSy9oy3ahjSgfQAAaT2g
References: <1321569820.1624.290.camel@localhost.localdomain> <FC1F9E38C0703341A1A750524E2525A901978CD9@XYUS-EX22.xyus.xyratex.com> <1321977410.1131.24.camel@Joe-Laptop>
From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
To: "Joe Perches" <joe@perches.com>
Cc: "Thomas Meyer" <thomas@m3y3r.de>, <JBottomley@parallels.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Achim Leubner" <Achim_Leubner@pmc-sierra.com>,
        "Mahesh Rajashekhara" <Mahesh_Rajashekhara@pmc-sierra.com>
X-OriginalArrivalTime: 22 Nov 2011 16:17:06.0422 (UTC) FILETIME=[2D879160:01CCA932]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aacraid@adaptec.com goes to them, I may have done a boo-boo by exposing
the current underlying addressees. As it stands the patch was not
addressed to any of the aacraid maintainers. The correct answer would
have been for me to Cc: aacraid@adaptec.com.

The MAINTAINERS file is *correct*. It has dealt with the arbitrary
transition of individual assigned maintainers within Adaptec (now PMC)
for nearly a decade now.

Sincerely -- Mark Salyzyn (former maintainer, interested party now)

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Joe Perches
Sent: Tuesday, November 22, 2011 10:57 AM
To: Mark Salyzyn
Cc: Thomas Meyer; JBottomley@parallels.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; Achim Leubner; Mahesh Rajashekhara
Subject: RE: [PATCH] [SCSI] aacraid: Use kmemdup rather than duplicating
its implementation

> -----Original Message-----
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/scsi/aacraid/commctrl.c

On Tue, 2011-11-22 at 06:24 -0800, Mark Salyzyn wrote:
> This driver is maintained by Achim Leubner
> <Achim_Leubner@pmc-sierra.com> and Mahesh Rajashekhara
> <Mahesh_Rajashekhara@pmc-sierra.com>. I have added them so that either
> one of them can have the opportunity to respond.
 
Really?  MAINTAINERS has:

AACRAID SCSI RAID DRIVER
M:	Adaptec OEM Raid Solutions <aacraid@adaptec.com>
L:	linux-scsi@vger.kernel.org
W:	http://www.adaptec.com/
S:	Supported
F:	Documentation/scsi/aacraid.txt
F:	drivers/scsi/aacraid/

Should either or both Achim or Mahesh be added?
