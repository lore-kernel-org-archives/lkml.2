Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab1KVP4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:56:53 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58244 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757356Ab1KVP4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:56:51 -0500
Message-ID: <1321977410.1131.24.camel@Joe-Laptop>
Subject: RE: [PATCH] [SCSI] aacraid: Use kmemdup rather than duplicating its
 implementation
From: Joe Perches <joe@perches.com>
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Cc: Thomas Meyer <thomas@m3y3r.de>, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Achim Leubner <Achim_Leubner@pmc-sierra.com>,
        Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>
Date: Tue, 22 Nov 2011 07:56:50 -0800
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A901978CD9@XYUS-EX22.xyus.xyratex.com>
References: <1321569820.1624.290.camel@localhost.localdomain>
	 <FC1F9E38C0703341A1A750524E2525A901978CD9@XYUS-EX22.xyus.xyratex.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

