Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967806Ab2ERBuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 21:50:44 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:35656 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966571Ab2ERBuk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 21:50:40 -0400
From: Yong Ding <yongd@marvell.com>
To: Chris Ball <cjb@laptop.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Philip Rakity <prakity@marvell.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "ulf.hansson@stericsson.com" <ulf.hansson@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 17 May 2012 18:49:49 -0700
Subject: RE: [PATCH v2] mmc:sdio:guarantee setting card data bus width as
 4-bit
Thread-Topic: [PATCH v2] mmc:sdio:guarantee setting card data bus width as
 4-bit
Thread-Index: Ac00KeAJyrwxFfY/Rli+d0agOJ48PwAbpPfw
Message-ID: <89813612683626448B837EE5A0B6A7CB1A2BA8F690@SC-VEXCH4.marvell.com>
References: <1337058583-2014-1-git-send-email-yongd@marvell.com>
 <87sjez3rvz.fsf@laptop.org>
In-Reply-To: <87sjez3rvz.fsf@laptop.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,
Thanks. And my full name is Yong Ding.

Best Wishes,

Yong Ding
Operating Systems Engineering,
Application Processor Systems Engineering

-----Original Message-----
From: Chris Ball [mailto:cjb@laptop.org] 
Sent: Thursday, May 17, 2012 8:38 PM
To: Yong Ding
Cc: linux-mmc@vger.kernel.org; Philip Rakity; ohad@wizery.com; linus.walleij@linaro.org; ulf.hansson@stericsson.com; linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mmc:sdio:guarantee setting card data bus width as 4-bit

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
