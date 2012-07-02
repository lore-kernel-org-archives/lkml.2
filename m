Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2GBPRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:17:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56506 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab2GBPRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:17:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: Re: [PATCH 1/4] [SCSI] ufs: Separate PCI glue driver for ufshcd
Date: Mon, 2 Jul 2012 15:17:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com,
        arnd@linaro.org, girish.shivananjappa@linaro.org,
        saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org,
        k.rajesh@samsung.com, yejin.moon@samsung.com, dsaxena@linaro.org,
        ilho215.lee@samsung.com, nala.la@samsung.com, stephen.doel@linaro.org,
        sreekumar.c@samsung.com
References: <1341239572-7408-1-git-send-email-vinholikatti@gmail.com> <1341239572-7408-2-git-send-email-vinholikatti@gmail.com>
In-Reply-To: <1341239572-7408-2-git-send-email-vinholikatti@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207021517.31537.arnd@arndb.de>
X-Provags-ID: V02:K0:bgfb/DVUF8XrkMcPSiOqUucsbhVTDCt364a9n9oI4K8
 sl4CA64fPSi3Hme+Y29RphDFzJKrC5nQ22nvE72TVqXppuPfVS
 08/ojmeLaFQEiNxqd35AMaHxoVMrTXPuLbnb4naJNF992LM2Yf
 KWHePZp8RHyAZYoVO9yxMvpsBtMhoOgkpUq8sm2Bhfz4XL+OFF
 0RnMg6ODfho90lMkgs3jOcM3TnSjIWxH2h2ihAuOGNrI3UDImh
 pVbZgcubQr4BuUfFFByvT3+eqFhelw5jFH0bsE3Hcpb67/FBX2
 TqoZ/DI45ZIeBtgVH9DQhMM8lv6klxZT2MM/mdXnefucufNEFw
 igo/ev808EjEnOMKe8OA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2012, Vinayak Holikatti wrote:
> 
> This patch separates PCI and core UFS host controller driver.
> In the current implementation PCI specific code is with ufshcd.c.
> To provide way for adding multiple bus glue driver, this patch
> separates PCI layer from ufshcd core. Now ufshcd compiles as separate
> module and ufshcd-pci as separate module.
> 
> Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
> Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>

Hi Vinayak,

This patch looks good at first sight, but it's a little hard to
review in the form that you are posting.

I would recommend that you split this patch into two separate
changesets, where you do all the changes to existing code in the
first patch, and only move but don't change code in the second one
that creates the new file.

	Arnd
