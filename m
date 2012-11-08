Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab2KHOfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:35:20 -0500
Received: from void.printf.net ([89.145.121.20]:60270 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab2KHOfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:35:17 -0500
From: Chris Ball <cjb@laptop.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Hogan <james.hogan@imgtec.com>, Will Newton <will.newton@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dw_mmc: fix more const pointer warnings
References: <1350376988-27477-1-git-send-email-james.hogan@imgtec.com>
	<508E4DB6.20504@imgtec.com> <87a9v5xuqj.fsf@octavius.laptop.org>
	<201211081426.12208.arnd@arndb.de>
Date: Thu, 08 Nov 2012 09:35:09 -0500
In-Reply-To: <201211081426.12208.arnd@arndb.de> (Arnd Bergmann's message of
	"Thu, 8 Nov 2012 14:26:11 +0000")
Message-ID: <87zk2s5fj6.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Nov 08 2012, Arnd Bergmann wrote:
> The patch "dw_mmc: fix multiple drv_data NULL dereferences" has
> unfortunately clashed with my "mmc: dw_mmc: constify
> dw_mci_idmac_ops in exynos back-end" patch, causing new warnings
> to appear.
>
> This should hopefully fix the issue for good.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, pushed to mmc-next for 3.7.

(Jaehoon also sent a patch to fix these last night, but yours applies to
current mmc-next and his doesn't, so I'll take this one instead.)

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
