Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab2IVTe3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 15:34:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34689 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2IVTe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 15:34:28 -0400
Date: Sat, 22 Sep 2012 15:34:26 -0400 (EDT)
Message-Id: <20120922.153426.978507671721485161.davem@davemloft.net>
To: peterhuewe@gmx.de
Cc: jacmet@sunsite.dk, david.daney@cavium.com, chohnstaedt@innominate.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] net/phy/bcm87xx: Add MODULE_LICENSE("GPL") to GPL
 driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1348281858-24366-1-git-send-email-peterhuewe@gmx.de>
References: <1348281858-24366-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Sat, 22 Sep 2012 04:44:18 +0200

> Currently the driver has no MODULE_LICENSE attribute in its source which
> results in a kernel taint if I load this:
> 
> root@(none):~# modprobe bcm87xx
> bcm87xx: module license 'unspecified' taints kernel.
> 
> Since the first lines of the source code clearly state:
>  * This file is subject to the terms and conditions of the GNU General
>  * Public License.  See the file "COPYING" in the main directory of this
>  * archive for more details.
> I think it's safe to add the MODULE_LICENSE("GPL") macro and thus remove
> the kernel taint.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Good catch, applied, thanks.
