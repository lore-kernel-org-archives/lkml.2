Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1JZADt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 20:03:49 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37101 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750968Ab1JZADs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 20:03:48 -0400
Message-ID: <1319587427.14932.7.camel@Joe-Laptop>
Subject: Re: [PATCH 1/6] Staging: hv: mousevsc: Make  boolean states  boolean
From: Joe Perches <joe@perches.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        dmitry.torokhov@gmail.com, Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 25 Oct 2011 17:03:47 -0700
In-Reply-To: <1319588392-9982-1-git-send-email-kys@microsoft.com>
References: <1319588311-9935-1-git-send-email-kys@microsoft.com>
	 <1319588392-9982-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 17:19 -0700, K. Y. Srinivasan wrote:
> Make some state that is boolean in nature, a boolean variable.
[]
> diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
[]
@@ -148,7 +148,7 @@ struct  mousevsc_prt_msg {
>   */
>  struct mousevsc_dev {
>  	struct hv_device	*device;
> -	unsigned char		init_complete;
> +	bool			init_complete;
>  	struct mousevsc_prt_msg	protocol_req;
>  	struct mousevsc_prt_msg	protocol_resp;
>  	/* Synchronize the request/response if needed */
> @@ -159,7 +159,7 @@ struct mousevsc_dev {
>  	unsigned char		*report_desc;
>  	u32			report_desc_size;
>  	struct hv_input_dev_info hid_dev_info;
> -	int			connected;
> +	bool			connected;
>  	struct hid_device       *hid_device;
>  };

One of the bools should be moved to be adjacent to the other.


