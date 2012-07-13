Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab2GMPpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:45:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60894 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab2GMPpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:45:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: Re: [PATCH V2 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
Date: Fri, 13 Jul 2012 15:45:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com,
        arnd@linaro.org, girish.shivananjappa@linaro.org,
        saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org,
        k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com,
        nala.la@samsung.com, sreekumar.c@samsung.com
References: <1342188465-20239-1-git-send-email-vinholikatti@gmail.com>
In-Reply-To: <1342188465-20239-1-git-send-email-vinholikatti@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207131545.28877.arnd@arndb.de>
X-Provags-ID: V02:K0:szfgtgIEmw/pCgt3lamu0YNqYaEYraRctxrR22Oa+xD
 puFWJ74Cye/QGODjnr75Un/FCOMWwvwQiWyi/Hy7yzvnuL7g8g
 mXemMo8XDTRS7ga/uX6h402ETCH711uHMbjTTIGcT8qTuQp57d
 16EhrFJz0V8I6iF0alAHboLdRtnn9rXKffw6sWbVBQVFT+Tz7i
 siN8pRT0XikBVgqimLv82hEpwc6V/jLRyUB0QawFxadsXhJjec
 UVhNJhdcAPoeLDK+6Dt3j1DJoG6dsbTVu3gar4haeQH6ceLMFR
 o9/YeVDBUgEkjMn7s1n8TnDxb3dwRyY8tKocRqqcrOtN9Tr2gH
 LU6SeQenIY6Li6noNYsU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 July 2012, Vinayak Holikatti wrote:
> This patch set adds following features
>  - Seprates PCI specific code from ufshcd.c to make it as core
>  - Adds PCI glue driver ufshcd-pci.c
>  - Adds Platform glue driver ufshcd-pltfrm.c
>  - Update correct transfer size in Command UPIU

Acked-by: Arnd Bergmann <arnd@arndb.de>
