Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1IHXGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:06:54 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:29173 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1IHXGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:06:46 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH] Staging: hv: storvsc: Show the modulename in
 /sys/class/scsi_host/*/proc_name
Thread-Topic: [PATCH] Staging: hv: storvsc: Show the modulename in
 /sys/class/scsi_host/*/proc_name
Thread-Index: AQHMbkRY3EQjOj8RN0GAPfVfCfDgvpVDssDg
Date: Thu, 8 Sep 2011 16:55:02 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081D2BE0@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <20110908162650.GA10699@aepfle.de>
In-Reply-To: <20110908162650.GA10699@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p88N6xKb027671



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Thursday, September 08, 2011 12:27 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: [PATCH] Staging: hv: storvsc: Show the modulename in
> /sys/class/scsi_host/*/proc_name
> 
> 
> mkinitrd relies on /sys/class/scsi_host/*/proc_name instead of
> /sys/block/sd*/device/../../../moalias to get the scsi driver module
> name.
> As a fallback the sysfs driver name could be used, which does not match
> the module name either ('storvsc' vs. 'hv_storvsc').
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> ---
>  drivers/staging/hv/storvsc_drv.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/drivers/staging/hv/storvsc_drv.c
> +++ b/drivers/staging/hv/storvsc_drv.c
> @@ -1333,7 +1333,8 @@ static DEF_SCSI_QCMD(storvsc_queuecomman
>  /* Scsi driver */
>  static struct scsi_host_template scsi_driver = {
>  	.module	=		THIS_MODULE,
> -	.name =			"storvsc_host_t",
> +	.name =			"hv_storvsc",
> +	.proc_name =		"hv_storvsc",
>  	.bios_param =		storvsc_get_chs,
>  	.queuecommand =		storvsc_queuecommand,
>  	.eh_host_reset_handler =	storvsc_host_reset_handler,

Acked-by:  K. Y. Srinivasan <kys@microsoft.com>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
