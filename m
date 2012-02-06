Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab2BFDHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 22:07:30 -0500
Received: from ozlabs.org ([203.10.76.45]:33257 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab2BFDH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 22:07:28 -0500
Date: Mon, 6 Feb 2012 14:07:24 +1100
From: David Gibson <hermes@gibson.dropbear.id.au>
To: Linus Torvalds <torvalds@osdl.org>, Pavel Roskin <proski@gnu.org>
Cc: orinoco-users@lists.sourceforge.net, orinoco-devel@lists.sourceforge.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: orinoco: Remove old mailing lists from MAINTAINERS
Message-ID: <20120206030724.GC18754@truffala.fritz.box>
Mail-Followup-To: Linus Torvalds <torvalds@osdl.org>,
	Pavel Roskin <proski@gnu.org>, orinoco-users@lists.sourceforge.net,
	orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two orinoco mailing lists on sourceforge were set up many years
ago and are now more or less moribund.  I'd like to shut them down, so
I don't have to keep filtering the spam from them (which is most of
what comes through now).  In preparation, this patch removes the
reference to them from the MAINTAINERS file.  Any remaining discussion
of this approaching obsolete driver can go to the linux-wireless list.

Please apply.

Signed-off-by: David Gibson <hermes@gibson.dropbear.id.au>

Index: working-2.6/MAINTAINERS
===================================================================
--- working-2.6.orig/MAINTAINERS	2012-02-06 12:24:27.933527295 +1100
+++ working-2.6/MAINTAINERS	2012-02-06 12:24:38.273578556 +1100
@@ -4906,8 +4906,6 @@ F:	fs/ocfs2/
 
 ORINOCO DRIVER
 L:	linux-wireless@vger.kernel.org
-L:	orinoco-users@lists.sourceforge.net
-L:	orinoco-devel@lists.sourceforge.net
 W:	http://linuxwireless.org/en/users/Drivers/orinoco
 W:	http://www.nongnu.org/orinoco/
 S:	Orphan

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
