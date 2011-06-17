Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab1FQQGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 12:06:01 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:37556 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759397Ab1FQQF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 12:05:59 -0400
Date: Fri, 17 Jun 2011 18:03:24 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: hjanssen@microsoft.com, kys@microsoft.com, v-abkane@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH 1/5] staging: hv: fix some white spaces in netvsc driver
Message-ID: <20110617180324.1eeb2ea0@absol.kitzblitz>
In-Reply-To: <1308322688-9796-1-git-send-email-haiyangz@microsoft.com>
References: <1308322688-9796-1-git-send-email-haiyangz@microsoft.com>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Haiyang Zhang <haiyangz@microsoft.com>:
> diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
> index 0ae35e7..b6e1fb9 100644
> --- a/drivers/staging/hv/netvsc.c
> +++ b/drivers/staging/hv/netvsc.c
> @@ -525,10 +525,10 @@ int netvsc_send(struct hv_device *device,
>  						  (unsigned long)packet);
>  	} else {
>  		ret = vmbus_sendpacket(device->channel, &sendMessage,
> -				       sizeof(struct nvsp_message),
> -				       (unsigned long)packet,
> -				       VM_PKT_DATA_INBAND,
> -				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> +				sizeof(struct nvsp_message),
> +				(unsigned long)packet,
> +				VM_PKT_DATA_INBAND,
> +				VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);

Why? The arguments were nicely aligned.

Best regards,
Nicolas Kaiser
