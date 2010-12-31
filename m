Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab0LaWQC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 17:16:02 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:18027 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754152Ab0LaWQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 17:16:00 -0500
Subject: Re: [PATCH 11/15]drivers:media:video:cx18:cx23418.h Typo change
 diable to disable.
From: Andy Walls <awalls@md.metrocast.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org
In-Reply-To: <1293750484-1161-11-git-send-email-justinmattock@gmail.com>
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
	 <1293750484-1161-2-git-send-email-justinmattock@gmail.com>
	 <1293750484-1161-3-git-send-email-justinmattock@gmail.com>
	 <1293750484-1161-4-git-send-email-justinmattock@gmail.com>
	 <1293750484-1161-5-git-send-email-justinmattock@gmail.com>
	 <1293750484-1161-6-git-send-email-justinmattock@gmail.com>
	 <1293750484-1161-7-git-send-email-justinmattock@gmail.com>
	 <1293750484-1161-8-git-send-email-justinmattock@gmail.com>
	 <1293750484-1161-9-git-send-email-justinmattock@gmail.com>
	 <1293750484-1161-10-git-send-email-justinmattock@gmail.com>
	 <1293750484-1161-11-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 16:15:20 -0500
Message-ID: <1293830120.2410.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-12-31_11:2010-12-31,2010-12-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1012310099
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-30 at 15:08 -0800, Justin P. Mattock wrote:
> The below patch fixes a typo "diable" to "disable". Please let me know if this 
> is correct or not.
     ^^^^^^^^^^^^^^

What, else could it be?  The "diablo" chroma spatial filter type? ;)

Looks fine.

Acked-by: Andy Walls <awalls@md.metrocast.net>

> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/media/video/cx18/cx23418.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/cx18/cx23418.h b/drivers/media/video/cx18/cx23418.h
> index 2c00980..7e40035 100644
> --- a/drivers/media/video/cx18/cx23418.h
> +++ b/drivers/media/video/cx18/cx23418.h
> @@ -177,7 +177,7 @@
>     IN[0] - Task handle.
>     IN[1] - luma type: 0 = disable, 1 = 1D horizontal only, 2 = 1D vertical only,
>  		      3 = 2D H/V separable, 4 = 2D symmetric non-separable
> -   IN[2] - chroma type: 0 - diable, 1 = 1D horizontal
> +   IN[2] - chroma type: 0 - disable, 1 = 1D horizontal
>     ReturnCode - One of the ERR_CAPTURE_... */
>  #define CX18_CPU_SET_SPATIAL_FILTER_TYPE     	(CPU_CMD_MASK_CAPTURE | 0x000C)
>  


