Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab1A1Rb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:31:56 -0500
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:35456 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753312Ab1A1Rby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:31:54 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-10.arcor-online.net 4E5BE2D6979
Subject: [PATCH] Registering ioctl number for hid-roccat chardev
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Weber <weber@corscience.de>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Jiri Kosina <jkosina@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 18:31:50 +0100
Message-ID: <1296235910.9030.1.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to add an ioctl to my already existing hid-roccat chardev
so that clients can inquire the report size. This would be needed
for planned enhancements.
The header actually resides in drivers/hid/hid-roccat.h and it is
planned to move and rename it to /include/linux/roccat.h along with
the ioctl implementation.
This patch is to register the number and development will begin as
soon as my choice is found to be good.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 Documentation/ioctl/ioctl-number.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 63ffd78..99cd8d9c 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -133,6 +133,7 @@ Code  Seq#(hex)	Include File		Comments
 'H'	C0-DF	net/bluetooth/hidp/hidp.h	conflict!
 'H'	C0-DF	net/bluetooth/cmtp/cmtp.h	conflict!
 'H'	C0-DF	net/bluetooth/bnep/bnep.h	conflict!
+'H'	F1	linux/roccat.h		<mailto:erazor_de@users.sourceforge.net>
 'I'	all	linux/isdn.h		conflict!
 'I'	00-0F	drivers/isdn/divert/isdn_divert.h	conflict!
 'I'	40-4F	linux/mISDNif.h		conflict!
-- 
1.7.3.4



