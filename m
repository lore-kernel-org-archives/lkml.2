Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab2ITPbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 11:31:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64648 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab2ITPbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 11:31:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the ixp4xx tree with the arm-soc tree
Date: Thu, 20 Sep 2012 15:31:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Krzysztof =?utf-8?q?Ha=C5=82asa?=" <khc@pm.waw.pl>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
References: <20120920163227.c6d8f1559b9cde971a376abf@canb.auug.org.au>
In-Reply-To: <20120920163227.c6d8f1559b9cde971a376abf@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209201531.50167.arnd@arndb.de>
X-Provags-ID: V02:K0:PT2T+HFwqXuHA5kg7wMtiSFeRn5xwICwLOQDoj5TvLB
 OA7vrRL5xqSQq3gNcQMxZUreMX2E2kQjiku/Mw3Eb2iwWjjLUC
 yd3d5+KCNee5eoLyYIo3v3Z/vSjRZQYggPwf4pJJDjNbK+R/0h
 Hrlfje2r0bfK5AvsYpE7sOMfWYGKhIrGniSwbhIcwI+evFJsjY
 YQFHbmZAmBePnQ89WuVmW7nHc9CjAo73zSCFnL84bdVYIt/5Yl
 fsLEgrisLXkYiyg1xDBR/ZoP3UgoZSpprnM4rxx8J3Yc9s3ysO
 a798RqflXbnUzsD0pWhndm5qmBz23owiH/L5xHrqDf3xSjRl4i
 F24HVrl0GYPtBMuEJzR0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2012, Stephen Rothwell wrote:
> Today's linux-next merge of the ixp4xx tree got conflicts in
> arch/arm/mach-ixp4xx/common.c and
> arch/arm/mach-ixp4xx/include/mach/ixp4xx-regs.h between commit
> 13ec32f47cb4 ("ARM: ixp4xx: use __iomem pointers for MMIO") from the
> arm-soc tree and commits 43690ab7543a ("IXP4xx: Always ioremap() Queue
> Manager MMIO region at boot") and f62736b567ff ("IXP4xx: map CPU config
> registers within VMALLOC region") from the ixp4xx tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Ok, thanks!

This conflict will go away once Krzysztof's patches make it into arm-soc.

	Arnd
