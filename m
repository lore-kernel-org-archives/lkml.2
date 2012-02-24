Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab2BXPK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:10:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60384 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab2BXPK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:10:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] bitops: Add missing parentheses to new get_order macro
Date: Fri, 24 Feb 2012 15:10:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        David Howells <dhowells@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
References: <1330088295-28732-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1330088295-28732-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201202241510.52609.arnd@arndb.de>
X-Provags-ID: V02:K0:TKK8UIvdaWNP7Mq9ELiTbrCrhuxgoX8nVJ16wmzsxJB
 uUHyK6cinrAY8hRQUQKaUzHD1s5rthwI6axdMDeECIKZdQhHYr
 k8co1sTEY5Xy+19gDYfJT9baOHYVax9+vh/xcteECVPSsa9m8/
 DhVuCDfueUSAKLG4kEV6jL9EI2IhYfm9BTNn3AvBTaHNKIyiOZ
 3/wAM+WLHXc931qCjbrY80qniq/1sx4GfdiOxIgbXQJPGKUj2N
 jLCotjfcfrS/Pql2naI8Rh0RGSfQYVjFdACiwEdCkrBS7dPpgN
 Ss+U/tPfe4n1hlxWwTdMbzKrugQEog0qtfC8kdCaW73knyzU3e
 sb6e6us3q3RNjKwdtybI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 February 2012, Joerg Roedel wrote:
>         d66acc39c7cee323733c8503b9de1821a56dff7e
> 
> does not use parentheses around all uses of the parameter n.
> This causes new compile warnings, for example in the
> amd_iommu_init.c function:
> 
> drivers/iommu/amd_iommu_init.c:561:6: warning: suggest parentheses around comparison in operand of ‘&’ [-Wparentheses]
> drivers/iommu/amd_iommu_init.c:561:6: warning: suggest parentheses around comparison in operand of ‘&’ [-Wparentheses]
> 
> Fix those warnings by adding the missing parentheses.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
