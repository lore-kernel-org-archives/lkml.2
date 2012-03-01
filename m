Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031049Ab2CAOGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 09:06:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58447 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031001Ab2CAOGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 09:06:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for DMA registration (3.3-rc)
Date: Thu, 1 Mar 2012 14:03:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
References: <4F4F49E1.4020902@atmel.com> <201203011149.42948.arnd@arndb.de> <4F4F7254.9060306@atmel.com>
In-Reply-To: <4F4F7254.9060306@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203011403.11369.arnd@arndb.de>
X-Provags-ID: V02:K0:9AM+qY+r/PLTGpmMkCUxoihJYgLTdEoU/vswergtORt
 Hr50tKwYmj/JfZOk0pKDaOelMIArIwkT2kQ/c/XqCa1Vw4jCsX
 kMwWFmI+kmikVs4H0ZHF866b+dYnq16mM343Qomugh1SIK0Ciw
 gFetruyO6cz1CRCK+eSNZHaqItF865bSo1OUxasR8BLcvwFHcj
 nDahz+FOvid4ZfGtkJ1+G/U3uvX89f5j4izdsZ655+9kCkRjTn
 7DC8gLuwhJjpz8CmWSTr/6DzhHuIpe94h3bXXTa99pxZGyuvuA
 S7fNjYY1kBwnLsI1fsHI+7h5dXBs4osrtzmTfVr5/TxVFgHTwQ
 3c+gxeQ4LpI/avJzi0rc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2012, Nicolas Ferre wrote:
> As discussed on the mailing-list, we experience an out-of-sync situation
> between the DMA controller driver and the related code in AT91 devices files.
> 
> Those two patches already queued for 3.4 are correcting the problem that we found on
> the current 3.3-rc kernels. I have tested that the DMA driver is registering well
> with those fixes applied.
> 
> Can you please pull them in a "fixes" branch and send them to Linus before 3.3-final?

Hi Nicolas,

I've just sent a pull request for bug fixes yesterday, so I'll wait
until Linus has pulled that one and probably a few days before I
send another one.

I have applied it to the fixes branch now but not updated the
tag that I sent him.

	Arnd
