Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab0CQVAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 17:00:21 -0400
Received: from 16.239.115-78.rev.gaoland.net ([78.115.239.16]:59905 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752941Ab0CQVAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 17:00:20 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2010 17:00:19 EDT
Date: Wed, 17 Mar 2010 21:52:06 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: =?utf-8?B?Su+/vXJu?= Engel <joern@dublin.logfs.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [Regression] r8169: enable 64-bit DMA by default for PCI Express
 devices (v2)
Message-ID: <20100317205206.GA2699@electric-eye.fr.zoreil.com>
Mail-Followup-To: Francois Romieu <romieu@fr.zoreil.com>,
	=?utf-8?B?Su+/vXJu?= Engel <joern@dublin.logfs.org>,
	Robert Hancock <hancockrwd@gmail.com>,
	David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20100315150806.GA15354@Dublin.logfs.org>
 <20100315151041.GA15667@Dublin.logfs.org>
 <20100315.115748.13754030.davem@davemloft.net>
 <51f3faa71003151628g5edc4d7av8916ac76cb337bfe@mail.gmail.com>
 <20100316083501.GA3489@Dublin.logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100316083501.GA3489@Dublin.logfs.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 09:35:01AM +0100, J�rn Engel wrote:
[...]
> I just noticed lspci is also unhappy.
> 
> With patch in:
> Bikini:~# lspci -vv > lspci
> pcilib: sysfs_read_vpd: read failed: Connection timed out.
>
> With patch reverted:
> Bikini:~# lspci -vv > lspci2
> Bikini:~# diff -u lspci*
> --- lspci       2010-03-16 09:03:02.000000000 +0100
> +++ lspci2      2010-03-16 09:09:36.000000000 +0100
> @@ -246,7 +246,7 @@
>                 Vector table: BAR=4 offset=00000000
>                 PBA: BAR=4 offset=00000800
>         Capabilities: [cc] Vital Product Data
> -               Not readable
> +               Unknown small resource type 00, will not decode more.

Neither looks good.

Did lspci output look different with an older kernel ?

-- 
Ueimor
