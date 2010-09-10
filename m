Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab0IJLkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:40:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:59751 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752737Ab0IJLkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:40:23 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+yodEEU16ydWaHQJnNRLpIMW3worX2rFRGSoQ+GD
	xLsaZPd4VOHr0Q
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: [Resend] uml build error for kernel v2.6.36-rc3-337-g48d00d6
Date: Fri, 10 Sep 2010 13:40:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.4; KDE/4.4.5; i686; ; )
Cc: user-mode-linux-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009101340.18552.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(had have problems with my mailer therefore probably you got this mail 
already)

The uml build is broken since some revisions, a build gives :

...
  CC      arch/um/drivers/hostaudio_kern.o
arch/um/drivers/hostaudio_kern.c: In function ‘hostaudio_open’:
arch/um/drivers/hostaudio_kern.c:204: error: ‘__param_dsp’ undeclared (first 
use in this function)
arch/um/drivers/hostaudio_kern.c:204: error: (Each undeclared identifier is 
reported only once
arch/um/drivers/hostaudio_kern.c:204: error: for each function it appears in.)
arch/um/drivers/hostaudio_kern.c: In function ‘hostmixer_open_mixdev’:
arch/um/drivers/hostaudio_kern.c:265: error: ‘__param_mixer’ undeclared (first 
use in this function)
arch/um/drivers/hostaudio_kern.c:272: error: ‘__param_dsp’ undeclared (first 
use in this function)
make[1]: *** [arch/um/drivers/hostaudio_kern.o] Error 1
make: *** [arch/um/drivers] Error 2


-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
0351d6a13e12f11697112d3c674bef5e
bd6a850f405771645536622adcd78f4cbe0edb9477040cef310e15e13282339d

