Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab2FROL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:11:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52015 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2FROL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:11:58 -0400
MIME-Version: 1.0
In-Reply-To: <007b01cd4d15$40673510$c1359f30$%jun@samsung.com>
References: <007b01cd4d15$40673510$c1359f30$%jun@samsung.com>
Date: Mon, 18 Jun 2012 23:11:56 +0900
Message-ID: <CAKYAXd82Y54=CQf2hRaXEZ_NrG9xE2-YTrsS9cFtFoCBv0u8YA@mail.gmail.com>
Subject: Re: [PATCH RESEND v7 2/3] mmc: core: Support packed write command for
 eMMC4.5 device
From: Namjae Jeon <linkinjeon@gmail.com>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Maya Erez <merez@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        "S, Venkatraman" <svenkatr@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/18 Seungwon Jeon <tgih.jun@samsung.com>:
> This patch supports packed write command of eMMC4.5 device.
> Several writes can be grouped in packed command and all data
> of the individual commands can be sent in a single transfer
> on the bus.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
this patch looks good to me also.
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>

Thanks.
