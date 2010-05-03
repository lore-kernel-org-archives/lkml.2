Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269Ab0ECN04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:26:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65513 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab0ECN0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:26:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=M7+1yj0xDNmnNijwaxiCS4EldOJnL0QM1l0FESjOo6CI1N2ioC8xIbnMtZhWz15Y6n
         PpqCpIs8ZR1cFaaysla0sot09++mFIHQQWOcdBIF2ecYhs8a9w5n8MCIFdiKVSF9h7g8
         CioXEbp7wVy9cnIFKx6HrwH8+STbrIm3tHJ9A=
Message-ID: <4BDECF24.8070604@gmail.com>
Date: Mon, 03 May 2010 06:27:00 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]trivial:Fix some comments.
References: <1272260842-2592-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1272260842-2592-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2010 10:47 PM, Justin P. Mattock wrote:
> Fix some comments.
>
> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> ---
>   drivers/gpu/drm/nouveau/nv50_display.c |    2 +-
>   drivers/s390/block/dasd_eckd.c         |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/nv50_display.c b/drivers/gpu/drm/nouveau/nv50_display.c
> index 649db4c..452ed31 100644
> --- a/drivers/gpu/drm/nouveau/nv50_display.c
> +++ b/drivers/gpu/drm/nouveau/nv50_display.c
> @@ -239,7 +239,7 @@ nv50_display_init(struct drm_device *dev)
>   	nv_wr32(dev, NV50_PDISPLAY_UNK_388, 0x150000);
>   	nv_wr32(dev, NV50_PDISPLAY_UNK_38C, 0);
>
> -	/* The precise purpose is unknown, i suspect it has something to do
> +	/* The precise purpose is unknown, I suspect it has something to do
>   	 * with text mode.
>   	 */
>   	if (nv_rd32(dev, NV50_PDISPLAY_INTR_1)&  0x100) {
> diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
> index 0cb2331..582c568 100644
> --- a/drivers/s390/block/dasd_eckd.c
> +++ b/drivers/s390/block/dasd_eckd.c
> @@ -2291,7 +2291,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
>   	} else
>   		return ERR_PTR(-EINVAL);
>
> -	/* trackbased I/O needs address all memory via TIDAWs,
> +	/* trackbased I/O needs to address all memory via TIDAWs,
>   	 * not just for 64 bit addresses. This allows us to map
>   	 * each segment directly to one tidaw.
>   	 */


no response on this
fame or shame?

Justin P. Mattock
