Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab3ACJex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:34:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab3ACJeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 04:34:50 -0500
Date: Thu, 3 Jan 2013 10:34:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, hsweeten@visionengravers.com
Subject: Re: [PATCH 2/3] HID: hid.h: remove unused hid_generic_{init,exit}
 prototypes
In-Reply-To: <201212171527.33761.hartleys@visionengravers.com>
Message-ID: <alpine.LNX.2.00.1301031034020.27348@pobox.suse.cz>
References: <201212171527.33761.hartleys@visionengravers.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012, H Hartley Sweeten wrote:

> These functions are not defined. Remove the extern declarations.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> ---
>  include/linux/hid.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index d6c71a6..828726c 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -884,9 +884,6 @@ static inline int hid_hw_power(struct hid_device *hdev, int level)
>  int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
>  		int interrupt);
>  
> -extern int hid_generic_init(void);
> -extern void hid_generic_exit(void);
> -
>  /* HID quirks API */
>  u32 usbhid_lookup_quirk(const u16 idVendor, const u16 idProduct);
>  int usbhid_quirks_init(char **quirks_param);

Applied.

-- 
Jiri Kosina
SUSE Labs
