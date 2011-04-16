Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab1DPJqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 05:46:52 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40444 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab1DPJqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 05:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aje/Wb1UJseyg8FTyYA7ULmEc4/LWCFj5e8yi5picmcvgARqDgQU9loLqxsk2YEtS/
         V2HTaNMiDfVc5onwP7g30/znrC7IJ5K7GSmlb+RIkAM6DLZILCqDkG2m4l9PCkvwM27r
         2N78W3ZnY4WuCrn8HfRGKRl1HLskDpCIU9Y1o=
MIME-Version: 1.0
In-Reply-To: <1301726499-6010-1-git-send-email-namei.unix@gmail.com>
References: <1301726499-6010-1-git-send-email-namei.unix@gmail.com>
Date: Sat, 16 Apr 2011 17:46:46 +0800
Message-ID: <BANLkTi=_vsX6Zx8b82FYWUy5WGxLdMBbMQ@mail.gmail.com>
Subject: Re: [PATCH] drivers, mfd: Remove unused variable 'val'
From: Liu Yuan <namei.unix@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Samuel, is there another similar fix already pending? I notice the
latest[ Linus tree[0ebc115da3ed6740, Fri Apr 15 20:31:15 2011 -0700]
still has this redundant variable.

Thanks,
Yuan

On Sat, Apr 2, 2011 at 2:41 PM, Liu Yuan <namei.unix@gmail.com> wrote:
> From: Liu Yuan <tailai.ly@taobao.com>
>
>
> Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
> ---
>  drivers/mfd/wl1273-core.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
> index 04914f2..37af778 100644
> --- a/drivers/mfd/wl1273-core.c
> +++ b/drivers/mfd/wl1273-core.c
> @@ -153,7 +153,6 @@ out:
>  */
>  static int wl1273_fm_set_volume(struct wl1273_core *core, unsigned int volume)
>  {
> -       u16 val;
>        int r;
>
>        if (volume > WL1273_MAX_VOLUME)
> --
> 1.7.1
>
>
