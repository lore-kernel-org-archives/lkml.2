Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab2HAOok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:44:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61834 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab2HAOoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:44:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: Re: [PATCH V3 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
Date: Wed, 1 Aug 2012 14:44:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, arnd@linaro.org,
        girish.shivananjappa@linaro.org, saugata.das@linaro.org,
        vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com,
        dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com,
        sreekumar.c@samsung.com
References: <1343292170-2599-1-git-send-email-vinholikatti@gmail.com>
In-Reply-To: <1343292170-2599-1-git-send-email-vinholikatti@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208011444.34598.arnd@arndb.de>
X-Provags-ID: V02:K0:HtD72nEJPg6Vb74/vUSxtont7KBshr5sA8IV2CpCgMD
 UNNfmzLTitDmDIZhHpq5WKFSDV+bB7qoG8NEnRcm1fZOExSR0W
 4sVFbSMcG3UTo1YZx0J28iDpuLuKzGWUvMpqUUAurTwpRNs4Sy
 7Zd9zlbm6BvFzQ7db3yAky6H7LBF4uHLtZlgTXRO3/XwC/xh1h
 /aKqHC45xtZ9nvpS5WWvMLXzEInaSr4YmylEYi2lhOyBE4Xm9i
 ustQi03unAm15DsWvyuRauklBh+fAgESvcrgzIJNOeogJAw90S
 9lEUFoJD75m+2HoV9pXVOKCWy7gWyxAJPgvFtz3Z70FtCGeabH
 DEFK+EMo9ttsmc9Cjg80=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2012, Vinayak Holikatti wrote:
> 
> This patch set adds following features
>  - Seggregate PCI specific code in ufshcd.c
>  - Adds PCI glue driver ufshcd-pci.c and ufshcd.c become core module
>  - Adds Platform glue driver ufshcd-pltfrm.c
>  - Update correct transfer size in Command UPIU

I've found a few trivial issues that I just replied on. Other than that,
please add my

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
