Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab2KTG6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:58:11 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61215 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab2KTG6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:58:09 -0500
MIME-Version: 1.0
In-Reply-To: <94587f7ddc4cf5503a1824df4c1fb53e553881b7.1352474824.git.viresh.kumar@linaro.org>
References: <3d6f34ca5960203a5efb761f4d56b4e10ee24827.1352474824.git.viresh.kumar@linaro.org>
	<94587f7ddc4cf5503a1824df4c1fb53e553881b7.1352474824.git.viresh.kumar@linaro.org>
Date: Tue, 20 Nov 2012 12:28:08 +0530
Message-ID: <CAKohpo=NyLCzu+1urTFTusigR7X9+jZy_z=ndgjyu4dOSOnAeg@mail.gmail.com>
Subject: Re: [PATCH 3/3] input:stmpe-ts:Initialize the phys field for input device
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 November 2012 20:57, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> From: Vipul Kumar Samar <vipulkumar.samar@st.com>
>
> Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
> ---
>  drivers/input/touchscreen/stmpe-ts.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/input/touchscreen/stmpe-ts.c b/drivers/input/touchscreen/stmpe-ts.c
> index 66b932e..9896095 100644
> --- a/drivers/input/touchscreen/stmpe-ts.c
> +++ b/drivers/input/touchscreen/stmpe-ts.c
> @@ -317,6 +317,7 @@ static int __devinit stmpe_input_probe(struct platform_device *pdev)
>                 return ret;
>
>         idev->name = STMPE_TS_NAME;
> +       idev->phys = STMPE_TS_NAME"/input0";
>         idev->id.bustype = BUS_I2C;
>         idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
>         idev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);

Missed this one too?
