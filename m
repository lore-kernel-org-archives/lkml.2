Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0ILWiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 18:38:21 -0400
Received: from 217.59.140-88.rev.gaoland.net ([88.140.59.217]:36624 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753892Ab0ILWiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 18:38:19 -0400
Date: Mon, 13 Sep 2010 00:37:25 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Heiko Bauke <heiko.bauke@snafu.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Realtek Ethernet drivers
Message-ID: <20100912223724.GA15934@electric-eye.fr.zoreil.com>
References: <20100912210444.76ebeee6@tron.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100912210444.76ebeee6@tron.localdomain>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please Cc: netdev@vger.kernel.org for network related issues.

Heiko Bauke <heiko.bauke@snafu.de> :
[...]
> in the last few weeks I spend quite some time trying to fix a network
> problem on my home server which has two Realtek onboard ethernet cards,
> lspci-output:
> 
> 00:0c.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8110SC/8169SC Gigabit Ethernet (rev 10)
> 00:0d.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8110SC/8169SC Gigabit Ethernet (rev 10)

It's probably fixed with one of :
- 81a95f049962ec20a9aed888e676208b206f0f2e / 024a07bacf8287a6ddfa83e9d5b951c5e8b4070e
- 908ba2bfd22253f26fa910cd855e4ccffb1467d0
- 78f1cd02457252e1ffbc6caa44a17424a45286b8

[...]
> P.S. I am running 2.6.32-24-generic on a 32-bit Ubuntu 10.04.1 LTS box.

Your 2.6.32-24-generic includes :
- 908ba2bfd22253f26fa910cd855e4ccffb1467d0
- 78f1cd02457252e1ffbc6caa44a17424a45286b8

But it misses 81a95f049962ec20a9aed888e676208b206f0f2e and
024a07bacf8287a6ddfa83e9d5b951c5e8b4070e

Please upgrade.

-- 
Ueimor
