Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2HRSId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 14:08:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59497 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2HRSIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 14:08:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 01/11] ARM: defconfig: Remove CONFIG_MISC_DEVICES
Date: Sat, 18 Aug 2012 18:08:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        linux-arm-kernel@lists.infradead.org
References: <1345307035-3545-1-git-send-email-festevam@gmail.com>
In-Reply-To: <1345307035-3545-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208181808.21484.arnd@arndb.de>
X-Provags-ID: V02:K0:lVrlKz2oWCToxfTg+n/NJfxw/j4ouR5ngVFwclP7b/s
 SoJAtaKX2xJwSpWF2YesLT9TRMOjZhIBkIAqMqeOvgnifQPMmI
 kIiREqpdHzh3hSdz6XNEBofm891S8mN2sAm/mp+p35/Mrz0Qaw
 mTWuVbN25CVFXu3K7oPHQmuS9iq+/mayUZYN1g8Fy0GNuBj6ZI
 LU4xXUoqWbSmBmgR5zcNzhcdgsgTuoT2hi6nIQxG4Oq5I05cZ8
 f4BcJlEICG4b6AAQBDDUmyLh9YpnE6hx3icyiRvNyx6uGjPbHH
 UUq7SfDjb96emL9gmKv4Jm4MSstUVaYFGk7g09JafXb+MACXso
 pkfLdOHj7CN4SNyeB/RY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 August 2012, Fabio Estevam wrote:
> 
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> commit 7c5763 (drivers:misc: Remove MISC_DEVICES config option) removed 
> CONFIG_MISC_DEVICES option, so remove the occurrences from the config files 
> as well.
> 
> Cc: <linux-arm-kernel@lists.infradead.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
