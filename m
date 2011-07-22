Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab1GVBfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 21:35:47 -0400
Received: from mail.perches.com ([173.55.12.10]:4228 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab1GVBfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 21:35:46 -0400
Subject: Re: [PATCH 2/9] staging: hv: add newline to log messages in netvsc
From: Joe Perches <joe@perches.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: hjanssen@microsoft.com, kys@microsoft.com, v-abkane@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
In-Reply-To: <1311268497-8671-3-git-send-email-haiyangz@microsoft.com>
References: <1311268497-8671-1-git-send-email-haiyangz@microsoft.com>
	 <1311268497-8671-3-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jul 2011 18:35:44 -0700
Message-ID: <1311298545.21930.3.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 10:14 -0700, Haiyang Zhang wrote:
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Just noticing some trivial typos...

> diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
[]
> @@ -246,7 +246,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
>  	if (init_packet->msg.v1_msg.
>  	    send_recv_buf_complete.status != NVSP_STAT_SUCCESS) {
>  		dev_err(&device->device, "Unable to complete receive buffer "
> -			   "initialzation with NetVsp - status %d",
> +			   "initialzation with NetVsp - status %d\n",

initialization

[]
> @@ -738,7 +738,7 @@ static void netvsc_receive(struct hv_device *device,
>  
>  	if (xferpage_packet->count != vmxferpage_packet->range_cnt) {
>  		dev_err(&device->device, "Needed %d netvsc pkts to satisy "
> -			"this xfer page...got %d",
> +			"this xfer page...got %d\n",

satisfy


