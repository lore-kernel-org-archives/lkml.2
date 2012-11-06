Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2KFWPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:15:36 -0500
Received: from void.printf.net ([89.145.121.20]:44335 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab2KFWPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:15:35 -0500
From: Chris Ball <cjb@laptop.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Will Newton <will.newton@imgtec.com>
Subject: Re: [PATCH 6/8] mmc: dw_mmc: constify dw_mci_idmac_ops in exynos back-end
References: <1352238933-4886-1-git-send-email-arnd@arndb.de>
	<1352238933-4886-7-git-send-email-arnd@arndb.de>
Date: Tue, 06 Nov 2012 17:15:31 -0500
In-Reply-To: <1352238933-4886-7-git-send-email-arnd@arndb.de> (Arnd Bergmann's
	message of "Tue, 6 Nov 2012 22:55:31 +0100")
Message-ID: <87hap28jjw.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, Nov 06 2012, Arnd Bergmann wrote:
> The of_device_id match data is now marked as const and
> must not be modified. This changes the dw_mmc to mark
> all pointers passing the dw_mci_drv_data or dw_mci_dma_ops
> structures as const, and also marks the static definitions
> as const.
>
> drivers/mmc/host/dw_mmc-exynos.c: In function 'dw_mci_exynos_probe':
> drivers/mmc/host/dw_mmc-exynos.c:234:11: warning: assignment discards 'const' qualifier from pointer target type [enabled by default]
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Will Newton <will.newton@imgtec.com>
> Cc: Chris Ball <cjb@laptop.org>

Thanks, pushed to mmc-next for 3.7.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
