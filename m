Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762505Ab2DLKOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 06:14:40 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:2776 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756169Ab2DLKOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 06:14:38 -0400
Message-ID: <1334225676.2439.12.camel@x61.thuisdomein>
Subject: [PATCH] Remove Marcel Selhorst as maintainer
From: Paul Bolle <pebolle@tiscali.nl>
To: Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Thu, 12 Apr 2012 12:14:36 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 12 Apr 2012 10:14:37.0006 (UTC) FILETIME=[10868EE0:01CD1895]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Messages to Marcel Selhorst's current address in MAINTAINERS trigger an
automated response. The (English part of the) response reads (in part):
    Thank you for your E-Mail. As of January 2012 I will not be available at
    this E-Mail address. Your mail will not be forwarded automatically.
    In case you have administration related issues, please consult [...];
    in case of technical issues please contact [...].

Neither of those two people seem to do anything kernel related.

Marcel Selhorst's last commit is over two years old. I suppose Marcel
can be removed as maintainer.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Marcel also has a MODULE_AUTHOR entry (using this address) in
tpm_infineon. What should be done with that entry?

 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a127097..21f11c5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6749,7 +6749,6 @@ TPM DEVICE DRIVER
 M:	Debora Velarde <debora@linux.vnet.ibm.com>
 M:	Rajiv Andrade <srajiv@linux.vnet.ibm.com>
 W:	http://tpmdd.sourceforge.net
-M:	Marcel Selhorst <m.selhorst@sirrix.com>
 W:	http://www.sirrix.com
 L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
-- 
1.7.7.6

