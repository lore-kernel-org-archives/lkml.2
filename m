Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab1DBUDq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 16:03:46 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53043 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab1DBUDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 16:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=wnYZAIQ3VTe6oiekqyxjy7PeRK35YaDO2OzMVSgu5w2S1KWjkS2jjLgnQaB7TC49Ra
         fLuwosAqZLa4RVsAEkdiu64WQ8Ff8aMSRCDmsSASEksgGXXz1TdjsZZwv/nrME/Nv+QZ
         qTS/41Nvyn69ZdHQyhtiPDeGuB8OyewE8L7Nc=
MIME-Version: 1.0
Date: Sat, 2 Apr 2011 15:03:43 -0500
Message-ID: <AANLkTinHAfGi84LWzP2rCqpzB6nmj-B2jU_pEPf89Lcz@mail.gmail.com>
Subject: [PATCH] Fixes a small error in Documentation/HOWTO
From: Someone Something <fordhaivat@gmail.com>
To: rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Description: This patch fixes a small error in Documentation/HOWTO
which gives a really old link for LXR.

This will be my first patch, so, any feedback is very welcome The
Patch follows this line. I'm not sure if I'm supposed to include the
HOWTO.orig stuff.


--- linux-2.6.38.2/Documentation/HOWTO.orig     2011-04-02
15:55:03.000000000 -0400
+++ linux-2.6.38.2/Documentation/HOWTO  2011-04-02 15:56:25.000000000 -0400
@@ -209,8 +209,7 @@ tools.  One such tool that is particular
 Cross-Reference project, which is able to present source code in a
 self-referential, indexed webpage format. An excellent up-to-date
 repository of the kernel code may be found at:
-       http://users.sosdg.org/~qiyong/lxr/
-
+       http://lxr.linux.no/linux+v2.6.38/Documentation/

 The development process
 -----------------------
