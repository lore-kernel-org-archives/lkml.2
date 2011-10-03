Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab1JCKlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:41:39 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:42678 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755151Ab1JCKlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:41:32 -0400
Message-ID: <4E898F99.8080507@ru.mvista.com>
Date: Mon, 03 Oct 2011 14:34:01 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: oskar.andero@sonyericsson.com
CC: Greg Kroah-Hartman <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hakan Kvist <hakan.kvist@sonyericsson.com>
Subject: Re: [PATCH] USB: ftdi_sio: add PID for Sony Ericsson Urban
References: <1317631891-13648-1-git-send-email-oskar.andero@sonyericsson.com>
In-Reply-To: <1317631891-13648-1-git-send-email-oskar.andero@sonyericsson.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03-10-2011 12:51, oskar.andero@sonyericsson.com wrote:

> From: Hakan Kvist <hakan.kvist@sonyericsson.com>

> Add PID 0xfc8a, 0xfc8b for device Sony Ericsson Urban

> Signed-off-by: Hakan Kvist <hakan.kvist@sonyericsson.com>
> Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
[...]

> diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
> index bf5227a..9617f91 100644
> --- a/drivers/usb/serial/ftdi_sio_ids.h
> +++ b/drivers/usb/serial/ftdi_sio_ids.h
> @@ -420,9 +420,11 @@
>   #define PROTEGO_SPECIAL_4	0xFC73	/* special/unknown device */
>
>   /*
> - * DSS-20 Sync Station for Sony Ericsson P800
> + * Sony Ericsson product ids
>    */
> -#define FTDI_DSS20_PID          0xFC82
> +#define FTDI_DSS20_PID          0xFC82 /* DSS-20 Sync Station for Sony Ericsson P800 */
> +#define FTDI_URBAN_0_PID        0xFC8A /* Sony Ericsson Urban, uart #0 */
> +#define FTDI_URBAN_1_PID        0xFC8B /* Sony Ericsson Urban, uart #1 */

    Please indent the values with tabs, not spaces.

WBR, Sergei

