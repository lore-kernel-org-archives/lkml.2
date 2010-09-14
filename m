Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab0INWmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:42:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56905 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab0INWmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:42:36 -0400
Date: Tue, 14 Sep 2010 15:41:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        Al Cho <acho@novell.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>
Subject: [PATCH -next] staging/keucr: update TODO list and ask question
 about it
Message-Id: <20100914154148.826a0334.randy.dunlap@oracle.com>
In-Reply-To: <20100913134302.a77e9a3e.sfr@canb.auug.org.au>
References: <20100913134302.a77e9a3e.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update keucr TODO with additional work items.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Al Cho <acho@novell.com>
---
 drivers/staging/keucr/TODO |    3 +++
 1 file changed, 3 insertions(+)

and I don't understand this TODO comment:
"	- determine if the driver should not be using a duplicate
	  version of the usb-storage scsi interface code, but should
	  be merged into the drivers/usb/storage/ directory and
	  infrastructure instead."

Of course the driver should not use a duplicate of the usb-storage
SCSI interface code.  Did someone seriously think that it should?


--- linux-next-20100913.orig/drivers/staging/keucr/TODO
+++ linux-next-20100913/drivers/staging/keucr/TODO
@@ -6,6 +6,9 @@ TODO:
 	  be merged into the drivers/usb/storage/ directory and
 	  infrastructure instead.
 	- review by the USB developer community
+	- common.h: use kernel swap, le, & be functions
+	- smcommon.h & smilsub.c: use kernel hweight8(), hweight16(),
+		strcmp(), & strcpy()
 
 Please send any patches for this driver to Al Cho <acho@novell.com> and
 Greg Kroah-Hartman <gregkh@suse.de>.
