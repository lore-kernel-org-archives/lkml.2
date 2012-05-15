Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966294Ab2EOSkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:40:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43554 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419Ab2EOSkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:40:07 -0400
Message-ID: <4FB2A302.9030602@lwfinger.net>
Date: Tue, 15 May 2012 13:40:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:rtl8712: Fix typo in rtl871x_io.h
References: <1337106859-13835-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1337106859-13835-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 01:34 PM, Masanari Iida wrote:
> Correct spelling typo "padater" to "padapter" in rtl871x_io.h
>
> Signed-off-by: Masanari Iida<standby24x7@gmail.com>
> ---
>   drivers/staging/rtl8712/rtl871x_io.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

In the prototype, it doesn't make much difference; however,

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

>
> diff --git a/drivers/staging/rtl8712/rtl871x_io.h b/drivers/staging/rtl8712/rtl871x_io.h
> index d3d8727..dc23395 100644
> --- a/drivers/staging/rtl8712/rtl871x_io.h
> +++ b/drivers/staging/rtl8712/rtl871x_io.h
> @@ -117,7 +117,7 @@ struct io_req {
>   	u32	command;
>   	u32	status;
>   	u8	*pbuf;
> -	void (*_async_io_callback)(struct _adapter *padater,
> +	void (*_async_io_callback)(struct _adapter *padapter,
>   				   struct io_req *pio_req, u8 *cnxt);
>   	u8 *cnxt;
>   };

