Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab1CFQsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 11:48:45 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62690 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab1CFQsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 11:48:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MgF4TXHN+ZtYBYmHMS7ilJnvqTXpITUabHjP5zSQ3EYwJokiINjh8+PfC9h9gTdk5D
         JFZRlYBRhozTxlUh0CiydF/SWCcPDGa3lW4Mp0/dNBmUbQXVLC2Nux+Jlmq+KKH7kVvN
         RaahXIOEjyhC8Cyzl6OjW5EuxESvtcBZDCseU=
Message-ID: <4D73BAE6.4000805@lwfinger.net>
Date: Sun, 06 Mar 2011 10:48:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiaochen Wang <wangxiaochen0@gmail.com>
CC: greg@kroah.com, florian.c.schilhabel@googlemail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] check _malloc return value in rtl8712
References: <20110306145321.GA20485@chii>
In-Reply-To: <20110306145321.GA20485@chii>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2011 08:53 AM, Xiaochen Wang wrote:
> Description: The original check is wrong.
>
> Signed-off-by: Xiaochen Wang<wangxiaochen0@gmail.com>
> ---
>   drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> index 685a7b1..51fef02 100644
> --- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> +++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> @@ -953,7 +953,7 @@ static int r871x_wx_set_priv(struct net_device *dev,
>
>   	len = dwrq->length;
>   	ext = _malloc(len);
> -	if (!_malloc(len))
> +	if (!ext)
>   		return -ENOMEM;
>   	if (copy_from_user(ext, dwrq->pointer, len)) {
>   		kfree(ext);

ACK.

Larry

