Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab1CBC7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 21:59:21 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18056 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab1CBC7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 21:59:20 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6272"; a="77261786"
Message-ID: <4D6DB287.4000102@codeaurora.org>
Date: Tue, 01 Mar 2011 18:59:19 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dima Zavin <dima@android.com>, Rohit Vaswani <rvaswani@codeaurora.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>, dwalker@fifo99.com,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] msm: gpiomux: Remove GPIOMUX_VALID and merge config enums
References: <4D680EEE.1070706@codeaurora.org>	<AANLkTinZCtbQnAk_OX92jqbW_GjH5wpxvbeoMkHV1inn@mail.gmail.com>	<4D689230.7020704@codeaurora.org> <AANLkTi=ePu9hTeecOfKoxKEXd6VZ6tJBN2XphDO5suOA@mail.gmail.com>
In-Reply-To: <AANLkTi=ePu9hTeecOfKoxKEXd6VZ6tJBN2XphDO5suOA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 06:25 PM, Dima Zavin wrote:
> Good point, ptr to anon struct would work.

Glad to know the suggestion helped.

> I would still very much like to see the helper macros be added though
> as it really would be very helpful in keeping the pinmuxing tidy in
> the board files. Doing it as a separate patch is fine.
>
> Other than the addition of helper macros, ack.

Rohit, would you mind adding the helper macros that use pointer to anon 
struct to simplify the GPIO config population in the board files? You 
can contact me offline if you need any help with it.

Thanks,
Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
