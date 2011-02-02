Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1BBMSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 07:18:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63867 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab1BBMSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 07:18:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Bernhard Walle <walle@corscience.de>
Subject: Re: [PATCH] spi: spidev: Add 32 bit compat ioctl()
Date: Wed, 2 Feb 2011 13:18:15 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
References: <1296646296-31843-1-git-send-email-walle@corscience.de>
In-Reply-To: <1296646296-31843-1-git-send-email-walle@corscience.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102021318.16191.arnd@arndb.de>
X-Provags-ID: V02:K0:wPB1lkmd+Hxo3F5subTKApyU9WBayPwNLCT8O9OKOst
 VkQLJ+7QLTZPswsXtJ+IkyRLl+5Ur4qoPdmLlHkWFQMaLN28zS
 /Ey80MJZ+JiyD9Xt2UvFdTOWf+fyxCFxpuKB2kwR/eBKgcf5l6
 5AOEh6GO8S25i8XUZkj0Fd5leuErRWHfpeVfiU2V5G9oV/qyMH
 9ZanfED6n/wVeREszN1GA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 February 2011, Bernhard Walle wrote:
> Add the compat_ioctl for operations on /dev/spi* so that 32 bit
> userspace applications can access SPI. As far as I can see all data
> structure are already prepared for that, so no additional conversion has
> to be done.
> 
> My use case is MIPS with N32 userspace ABI and toolchain, and that was
> also the platform where I tested it successfully (Cavium Octeon).
> 
> Signed-off-by: Bernhard Walle <walle@corscience.de>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
