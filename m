Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab2LUTEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 14:04:25 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:41945 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2LUTEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 14:04:20 -0500
Date: Fri, 21 Dec 2012 13:04:16 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 00/19] MAINTAINERS: fix file patterns
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
	<1355264351.24219.8.camel@joe-AO722> <1356105142.19585.13.camel@joe-AO722>
In-Reply-To: <1356105142.19585.13.camel@joe-AO722> (from joe@perches.com on
	Fri Dec 21 09:52:22 2012)
X-Mailer: Balsa 2.4.11
Message-Id: <1356116656.21178.1@driftwood>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-WWX37GV8SIzjQgIuh1gt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-WWX37GV8SIzjQgIuh1gt
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12/21/2012 09:52:22 AM, Joe Perches wrote:
> On Tue, 2012-12-11 at 14:19 -0800, Joe Perches wrote:
> > On Tue, 2012-12-11 at 19:49 -0200, Cesar Eduardo Barros wrote:
> > > I could not find the maintainer for the MAINTAINERS file, so =20
> sending
> > > directly to Linus. Sorry if I am mistaken.
> >
> > Thanks Cesar.
> >
> > Most maintainers patches are picked up by Andrew Morton (cc'd)

Which implies... (attached because Balsa damages whitespace).

Rob=

--=-WWX37GV8SIzjQgIuh1gt
Content-Type: text/x-patch; charset=us-ascii; name=maintainers.patch
Content-Disposition: attachment; filename=maintainers.patch

diff --git a/MAINTAINERS b/MAINTAINERS
index 4e2a1f6..3c30157 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -646,7 +646,7 @@ F:	arch/arm/
 
 ARM SUB-ARCHITECTURES
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	MAINTAINED
+S:	Maintained
 F:	arch/arm/mach-*/
 F:	arch/arm/plat-*/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
@@ -4859,6 +4859,11 @@ S:	Maintained
 F:	drivers/net/macvlan.c
 F:	include/linux/if_macvlan.h
 
+MAINTAINERS: UPDATES TO THIS FILE
+M:	Andrew Morton <akpm@linux-foundation.org>
+S:	Maintained
+F:	MAINTAINERS
+
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
 M:	Michael Kerrisk <mtk.manpages@gmail.com>
 W:	http://www.kernel.org/doc/man-pages

--=-WWX37GV8SIzjQgIuh1gt--
