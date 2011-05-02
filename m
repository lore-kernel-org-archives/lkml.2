Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab1EBPwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:52:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab1EBPwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:52:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [RFC PATCH 4/4] ARM: Xilinx: Adding Xilinx board support
Date: Mon, 2 May 2011 17:52:25 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20110502045207.24800.91172.stgit@ponder> <201105021039.32374.arnd@arndb.de> <4DBEB1A8.3040202@gmail.com>
In-Reply-To: <4DBEB1A8.3040202@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105021752.25273.arnd@arndb.de>
X-Provags-ID: V02:K0:QTI0iv4dajP7UHZTpDLEZL8Nbxz9xt68uiN3Yu4Vmfh
 LNHKflFZfJ/EPAZnKFGi4ZIGafLsDwPCZbiXXoB3OogCCSxa/V
 uwX+oF6iccT7QieZLdm4IF1pum8VyYMKr5udZ1XqujFBWzU6PZ
 XmCgH95rFYXH8IUBmesMyvj4Pf96bY8yXTxhc194IDk3L+1VYN
 G9dPN0/WuzGt14UMRlUJw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 May 2011, Rob Herring wrote:
> The SCU is accessed before ioremap is up. The only reason it is accessed 
> early is to determine the number of cores present.

The number of cores should definitely be available in the device tree,
normally by looking at the root interrupt controller.

> The L2 can certainly be ioremapped and probed via DT. How about 
> something like this:
> 
>         l2cc {
>                 compatible = "arm,pl310-l2";
>                 reg = <0xfff12000 0x1000>;
>                 aux-value = <0>;
>                 aux-mask = <0xffffffff>;
>         };

sounds good to me.

	Arnd
