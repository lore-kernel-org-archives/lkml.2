Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064Ab2KAPqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:46:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60436 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010Ab2KAPqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:46:51 -0400
Date: Thu, 01 Nov 2012 11:46:42 -0400 (EDT)
Message-Id: <20121101.114642.1433440763058405336.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, havard@skinnemoen.net, bhutchings@solarflare.com,
        linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
        manabian@gmail.com, David.Laight@ACULAB.COM
Subject: Re: [PATCH v4 00/10] net/macb: driver enhancement concerning GEM
 support, ring logic and cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1351690694.git.nicolas.ferre@atmel.com>
References: <cover.1351690694.git.nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Wed, 31 Oct 2012 17:04:49 +0100

> This is an enhancement work that began several years ago. I try to catchup with
> some performance improvement that has been implemented then by Havard.
> The ring index logic and the TX error path modification are the biggest changes
> but some cleanup/debugging have been added along the way.
> The GEM revision will benefit from the Gigabit support.
> Newer pinctrl infrastructure support is added but it is optional.
> 
> The series has been tested on several Atmel AT91 SoC with the two MACB/GEM
> flavors.
> 
> v4: - remove unneeded device tree header includes
>     - modified the computation of available entries in ring buffer
> v3: - rebased on net-next to take into account current effor to merge
>       at91_ether with macb drivers
>     - add additional patch to use the new pinctrl infrastructure
> v2: - modify the tx error handling: now uses a workqueue
>     - information provided by ethtool -i were not accurate: removed

Series applied to net-next
