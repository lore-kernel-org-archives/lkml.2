Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab1E3EkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 00:40:00 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:38220 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750739Ab1E3Ej7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 00:39:59 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX195i0lc4M15cyriQvzJML+g+QH2ZU2Kvokf4DGDFh
	s0ACd/MX8UN99Y
Subject: [sound] 3.0.0-rc1 build failure when CONFIG_GPIO not set
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 06:39:56 +0200
Message-ID: <1306730396.969.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
 CC [M]  sound/soc/codecs/ak4641.o
sound/soc/codecs/ak4641.c: In function ‘ak4641_probe’:
sound/soc/codecs/ak4641.c:524:6: error: ‘GPIOF_OUT_INIT_LOW’ undeclared (first use in this function)
sound/soc/codecs/ak4641.c:524:6: note: each undeclared identifier is reported only once for each function it appears in
make[3]: *** [sound/soc/codecs/ak4641.o] Error 1
make[2]: *** [sound/soc/codecs] Error 2
make[1]: *** [sound/soc] Error 2
make: *** [sound] Error 2
make: *** Waiting for unfinished jobs....


