Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2H3Bwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 21:52:42 -0400
Received: from void.printf.net ([89.145.121.20]:44615 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab2H3Bwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 21:52:40 -0400
From: Chris Ball <cjb@laptop.org>
To: IAN CHEN <ian.cy.chen@samsung.com>
Cc: linkinjeon@gmail.com, adrian.hunter@intel.com, subhashj@codeaurora.org,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, d.j.shin@samsung.com,
        jongtae22.kim@samsung.com, kyungmin.park@samsung.com,
        jh80.chung@samsung.com
Subject: Re: [PATCH v6] mmc: card: Skip secure option for MoviNAND.
References: <503DB130.8090807@samsung.com>
	<873936vvrg.fsf@octavius.laptop.org>
	<000401cd864f$e881a000$b984e000$%cy.chen@samsung.com>
Date: Wed, 29 Aug 2012 21:52:21 -0400
In-Reply-To: <000401cd864f$e881a000$b984e000$%cy.chen@samsung.com> (IAN CHEN's
	message of "Thu, 30 Aug 2012 10:36:42 +0900")
Message-ID: <87zk5dqh7u.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 29 2012, IAN CHEN wrote:
> Thanks for your help.
> The effected kernel will be all the version with MMC_CAP_ERASE & SECURE
> option enabled.
> As commit content mentioned, the problem is unrecoverable corruption after
> SECURE ERASE or SECURE TRIM.
> For devices using defective eMMC with kernel supporting MMC_CAP_ERASE &
> SECURE option, this issue might cause damage.
> Therefore, we skip secure for these known devices.

Thanks, pushed to mmc-next for 3.6 with a stable@ tag.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
