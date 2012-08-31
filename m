Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185Ab2HaHzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 03:55:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39795 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2HaHzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 03:55:53 -0400
X-AuditID: cbfee60d-b7f526d000004e6b-42-50406e08ebd0
Date: Fri, 31 Aug 2012 07:55:52 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/2] [1/2]extcon: standard cable names definition and
 declaration changed
To: anish kumar <anish198519851985@gmail.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120831075540994@myungjoo.ham
Msgkey: 20120831075540994@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120831075540994@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <26422216.93141346399752014.JavaMail.weblogic@epml19>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t/t6boceQ4BBs9uqllc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MlrkbmAs+CVcsnOfdwLhGuIuRk0NIQF1i0ZKTbCC2hICJxPz7
	55ggbDGJC/fWs0HUzGeU+HVYFMRmEVCV+H+tibGLkYODTUBPYubnZJCwsECsxM1Z39hBbBGB
	HIlZK5vBxjALOEo8unyHGWKMksSafa9YQGxeAUGJkzOfsICMkQAa+ftyBURYTWLTpp/MEBdI
	SMyafoEVwuaVmNH+lAXClpOY9nUNVI20xPlZGxhhLl78/TFUnF/i2O0dTBDjeSWe3A+GGbN7
	8xeoZwUkpp45CNWqJXHs+kaoOJ/EmoVvWWDG7Dq1nBmm9/6WuVBfKUpM6X7IDmFrSXz5sY8N
	1VcgtqPEsfPTmCcwys1CkpqFpH0WknZkNQsYWVYxiqYWJBcUJ6WnGusVJ+YWl+al6yXn525i
	BMf3M94djHMbLA4xCnAwKvHwTjhoHyDEmlhWXJl7iFGCg1lJhJfNyiFAiDclsbIqtSg/vqg0
	J7X4EKM0B4uSOO8Xr6/+QgLpiSWp2ampBalFMFkmDk6pBsaayfffJVz+vVUlV8A7Tlp+9ZsA
	7k4+gyUM+vJlQmsb13/PTQuu/VCb8elpshZj9rTi5onGe2/uizlu+t5qzbb1RepPV2drrHrN
	1WV++3Gs51WzZ9vjLtyaYLL3X71dR69OmcbPUlebpBcbTnx8V5dz4NVDtW+SDIGXHpf3LWFS
	2vRMX28bZ6ASS3FGoqEWc1FxIgBh/sf66wIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7V7uKQB028300

> From: anish kumar <anish198519851985@gmail.com>
> 
> With this change now individual drivers can use standard cable
> names as below:
> static const char *arizona_cable[] = {
>     extcon_cable_name[EXTCON_USB],
>     extcon_cable_name[EXTCON_USB_HOST],
>     "CUSTOM_CABLE"
>     NULL,
> }
> 
> Signed-off-by: anish kumar <anish198519851985@gmail.com>

Looks good.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>


> ---
>  drivers/extcon/extcon-class.c |    4 +---
>  include/linux/extcon.h        |    2 +-
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 481cfa0..e09a6c3 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -41,7 +41,7 @@
>   * every single port-type of the following cable names. Please choose cable
>   * names that are actually used in your extcon device.
>   */
> -const char *extcon_cable_name[] = {
> +const char extcon_cable_name[][CABLE_NAME_MAX + 1] = {
>  	[EXTCON_USB]		= "USB",
>  	[EXTCON_USB_HOST]	= "USB-Host",
>  	[EXTCON_TA]		= "TA",
> @@ -62,8 +62,6 @@ const char *extcon_cable_name[] = {
>  	[EXTCON_VIDEO_IN]	= "Video-in",
>  	[EXTCON_VIDEO_OUT]	= "Video-out",
>  	[EXTCON_MECHANICAL]	= "Mechanical",
> -
> -	NULL,
>  };
>  
>  static struct class *extcon_class;
> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> index cdd4014..96b5450 100644
> --- a/include/linux/extcon.h
> +++ b/include/linux/extcon.h
> @@ -68,7 +68,7 @@ enum extcon_cable_name {
>  	EXTCON_VIDEO_OUT,
>  	EXTCON_MECHANICAL,
>  };
> -extern const char *extcon_cable_name[];
> +extern const char extcon_cable_name[][CABLE_NAME_MAX + 1];
>  
>  struct extcon_cable;
>  
> -- 
> 1.7.1
> 
> 
> 
> 
>        
>   
>          
> A
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
