Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab1IAMyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:54:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56410 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab1IAMyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:54:35 -0400
Message-ID: <4E5F8053.4080603@ru.mvista.com>
Date: Thu, 01 Sep 2011 16:53:39 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Shaun Kluzek <g0del@bigpond.com>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB GADGET: u_serial.c: fixed a brace and whitespace
 coding style issue
References: <20110831072254.GA9706@epione>
In-Reply-To: <20110831072254.GA9706@epione>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 31-08-2011 11:22, Shaun Kluzek wrote:

> Signed-off-by: Shaun Kluzek<g0del@bigpond.com>
> ---
>   drivers/usb/gadget/u_serial.c |    5 +----
>   1 files changed, 1 insertions(+), 4 deletions(-)

> diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
> index a8aa469..b86022f 100644
> --- a/drivers/usb/gadget/u_serial.c
> +++ b/drivers/usb/gadget/u_serial.c
> @@ -552,11 +552,8 @@ recycle:
>   	/* Push from tty to ldisc; without low_latency set this is handled by
>   	 * a workqueue, so we won't get callbacks and can hold port_lock
>   	 */
> -	if (tty && do_push) {
> +	if (tty && do_push)
>   		tty_flip_buffer_push(tty);
> -	}
> -

    What's wrong with the first empty line here?

> -
>   	/* We want our data queue to become empty ASAP, keeping data
>   	 * in the tty and ldisc (not here).  If we couldn't push any
>   	 * this time around, there may be trouble unless there's an

WBR, Sergei
