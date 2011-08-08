Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab1HHVak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 17:30:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab1HHVak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 17:30:40 -0400
Message-ID: <4E40555E.90904@redhat.com>
Date: Mon, 08 Aug 2011 17:30:06 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Postbox Express 1.0.1 (Macintosh/20100705)
MIME-Version: 1.0
To: stufever@gmail.com
CC: linux-kernel@vger.kernel.org, mchehab@infradead.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Subject: Re: [PATCH] media: declare redrat3_init_rc_dev with the same parameter
 types
References: <1312651155-21891-1-git-send-email-wangshaoyan.pt@taobao.com>
In-Reply-To: <1312651155-21891-1-git-send-email-wangshaoyan.pt@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stufever@gmail.com wrote:
> From: Wang Shaoyan<wangshaoyan.pt@taobao.com>
>
>    drivers/media/rc/redrat3.c: In function 'redrat3_init_rc_dev':
>    drivers/media/rc/redrat3.c:1107: warning: assignment from incompatible pointer type
>
> Signed-off-by: Wang Shaoyan<wangshaoyan.pt@taobao.com>
> ---
>   drivers/media/rc/redrat3.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
> index a166044..332ffa4 100644
> --- a/drivers/media/rc/redrat3.c
> +++ b/drivers/media/rc/redrat3.c
> @@ -912,7 +912,7 @@ static int redrat3_set_tx_carrier(struct rc_dev *dev, u32 carrier)
>   	return carrier;
>   }
>
> -static int redrat3_transmit_ir(struct rc_dev *rcdev, int *txbuf, u32 n)
> +static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf, unsigned n)
>   {
>   	struct redrat3_dev *rr3 = rcdev->priv;
>   	struct device *dev = rr3->dev;

Not sure if this change is complete. See the mceusb.c changes in commit 
5588dc2b025fd8b2188142b8d59efe562bd57d80. Fixing this is on my TODO 
list, and I have the hardware to test, just haven't got to it yet. 
Actually, I have a patch that closely matches the referenced mceusb.c 
changes now, I just need to test it out...

-- 
Jarod Wilson
jarod@redhat.com


