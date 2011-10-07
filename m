Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1JGPmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 11:42:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51646 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1JGPmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 11:42:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: linux-next: build failure after merge of the arm-soc tree
Date: Fri, 7 Oct 2011 17:41:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
References: <20111004112623.aa04e959d29cb19af8053739@canb.auug.org.au> <20111006111317.531e6fcc1829fc9927d4924d@canb.auug.org.au> <4E8EC1D8.4070200@atmel.com>
In-Reply-To: <4E8EC1D8.4070200@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110071741.49151.arnd@arndb.de>
X-Provags-ID: V02:K0:xz4Ishf5Lnf8FCBboTnU2QfgOWPU0Ybgg3xME4Do3m/
 JOD3GpQSIyAXape46AXW0bBswg5ln8fW/B0xxm/npN1sKqBiDx
 VYFr2GqwZUTUJ2PDGTBJb6hYCDexDSlF6m8iXNoL9fawKMEfYn
 RECP4a15oCw0r4J8q4Mcb0eVESf206pzKubBZ3w6J59vxbTe/A
 +pLI70bGWAhxFZLpZ8+UuPqBIbprTcINi610qXdBfL99vGB/90
 dHzgJX5jz+1rEndVirtpO/+JKQQRCn8KOpyxyclro9RQaLxr/x
 qsbBSDqhUZvrEN0q7RqGYNcA+sH9eBdn/U6XZW3bTZj8ccm4PQ
 P3U0+oZEih8zObNAzvN4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 October 2011, Nicolas Ferre wrote:
> Well, on my side, applying Arnd's correction, I can run a x86_64
> allmodconfig without this error.
> 
> With this new dependency it seems impossible to even select the driver.
> 
> Do you have a link to a log of this failure? Have the .config been
> re-generated?
> 

I just had not gotten around to do the changes I promised. It should
be ok in arm-soc/for-next now.

	Arnd
