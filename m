Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965623Ab2EQMhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:37:50 -0400
Received: from void.printf.net ([89.145.121.20]:50771 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab2EQMhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:37:48 -0400
From: Chris Ball <cjb@laptop.org>
To: yongd <yongd@marvell.com>
Cc: linux-mmc@vger.kernel.org, prakity@marvell.com, ohad@wizery.com,
        linus.walleij@linaro.org, ulf.hansson@stericsson.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mmc:sdio:guarantee setting card data bus width as 4-bit
References: <1337058583-2014-1-git-send-email-yongd@marvell.com>
Date: Thu, 17 May 2012 08:37:36 -0400
In-Reply-To: <1337058583-2014-1-git-send-email-yongd@marvell.com>
	(yongd@marvell.com's message of "Tue, 15 May 2012 13:09:43 +0800")
Message-ID: <87sjez3rvz.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 15 2012, yongd wrote:
>   SDIO_CCCR_IF[1:0] in SDIO card is used for card data bus width
> setting as below,
>      00b: 1-bit bus
>      01b: Reserved
>      10b: 4-bit bus
>      11b: 8-bit bus(only for embedded SDIO)
>   And sdio_enable_wide is for setting data bus width as 4-bit. But
> currently, it 1stly read the register, 2ndly OR' 1b with SDIO_CCCR_IF[1],
> and then write it back.
>   As we can see, such way is based on such assumption that the
> SDIO_CCCR_IF[0] is always 0. Apparently, this is not right.
>
> Signed-off-by: yongd <yongd@marvell.com>

Thanks.  Can we have your full name, for the copyright record?

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
