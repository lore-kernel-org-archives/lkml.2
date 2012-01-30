Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2A3FnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 00:43:04 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46172 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937Ab2A3FnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 00:43:02 -0500
MIME-Version: 1.0
In-Reply-To: <1327841453-1674-1-git-send-email-standby24x7@gmail.com>
References: <1327841453-1674-1-git-send-email-standby24x7@gmail.com>
Date: Mon, 30 Jan 2012 14:43:01 +0900
X-Google-Sender-Auth: TvMkjYfs3lj8fzTuqmaVq5njHcY
Message-ID: <CAH9JG2USF-FYX0SL-y0Gby8oNvA=sFBV7uyvP+4oaa1nxRU5qA@mail.gmail.com>
Subject: Re: [PATCH] [trivial] media: Fix typo in mixer_drv.c and hdmi_drv.c
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Masanari Iida <standby24x7@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On 1/29/12, Masanari Iida <standby24x7@gmail.com> wrote:
> Correct typo "sucessful" to "successful" in
> drivers/media/video/s5p-tv/mixer_drv.c
> drivers/media/video/s5p-tv/hdmi_drv.c
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/media/video/s5p-tv/hdmi_drv.c  |    4 ++--
>  drivers/media/video/s5p-tv/mixer_drv.c |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c
> b/drivers/media/video/s5p-tv/hdmi_drv.c
> index 8b41a04..3e0dd09 100644
> --- a/drivers/media/video/s5p-tv/hdmi_drv.c
> +++ b/drivers/media/video/s5p-tv/hdmi_drv.c
> @@ -962,7 +962,7 @@ static int __devinit hdmi_probe(struct platform_device
> *pdev)
>  	/* storing subdev for call that have only access to struct device */
>  	dev_set_drvdata(dev, sd);
>
> -	dev_info(dev, "probe sucessful\n");
> +	dev_info(dev, "probe successful\n");
>
>  	return 0;
>
> @@ -1000,7 +1000,7 @@ static int __devexit hdmi_remove(struct
> platform_device *pdev)
>  	iounmap(hdmi_dev->regs);
>  	hdmi_resources_cleanup(hdmi_dev);
>  	kfree(hdmi_dev);
> -	dev_info(dev, "remove sucessful\n");
> +	dev_info(dev, "remove successful\n");
>
>  	return 0;
>  }
> diff --git a/drivers/media/video/s5p-tv/mixer_drv.c
> b/drivers/media/video/s5p-tv/mixer_drv.c
> index 0064309..a2c0c25 100644
> --- a/drivers/media/video/s5p-tv/mixer_drv.c
> +++ b/drivers/media/video/s5p-tv/mixer_drv.c
> @@ -444,7 +444,7 @@ static int __devexit mxr_remove(struct platform_device
> *pdev)
>
>  	kfree(mdev);
>
> -	dev_info(dev, "remove sucessful\n");
> +	dev_info(dev, "remove successful\n");
>  	return 0;
>  }
>
> --
> 1.7.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
