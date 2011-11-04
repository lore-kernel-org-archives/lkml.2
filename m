Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab1KDNAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:00:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54243 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1KDNAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:00:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vinod Koul <vinod.koul@intel.com>, Kukjin Kim <kgene.kim@samsung.com>
Subject: arm-soc samsung patches blocked on dmaengine patches
Date: Fri, 4 Nov 2011 14:00:43 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111041400.44486.arnd@arndb.de>
X-Provags-ID: V02:K0:C5Y5y8WAkqQfSqDAt0sSyHD0/R5oDPrs7LAwWj2dmCm
 DuAyN8uIxsY6TAaJotGuj6B7p3RjhAuFguSQWKPZTXtzyvWZf5
 11j6dToi3bxbRBZ9pa53UtYxxba3hLs3ogCVHAb+xO4oxPSbaA
 eBQ9WuGGsYckE6+T18O7xAY9xjfAGGqF3ucXItXK12qSql9XrS
 cCeLVE/BffdkvURDAj1euAmhs43Kz2qdK1jeR2W9RKngrz6453
 iS3kbmi/Y8SiqbSi0Pb31NhphHXPl5U18BYBcp2/l/6wPBPaxA
 Ts3Qz+7qAAe+iiXbpAD0fUYkDkYmmabAFisFk30Fpj26LVv7bJ
 5umC0BXzYpYr1OZ4pdao=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod and Kukjin,

Right now, all the patches from the arm-soc tree are merged into 3.2, but the
samsung/cleanup and samsung/devel series are missing because they depend on
patches in the dmaengine tree. I'm not sure about the status of that tree,
but I didn't see a pull request for them yet.

Should I just submit the samsung tree with the dmaengine patches included,
or keep waiting?

	Arnd
