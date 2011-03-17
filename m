Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1CQLBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:01:52 -0400
Received: from smtp.nokia.com ([147.243.1.47]:45612 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab1CQLBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:01:49 -0400
Date: Thu, 17 Mar 2011 12:59:24 +0200 (EET)
From: Aaro Koskinen <aaro.koskinen@nokia.com>
X-X-Sender: aakoskin@esdhcp041196.research.nokia.com
To: Darek Iwanski <darekiwanski13@gmail.com>
cc: gregkh@suse.de, apatard@mandriva.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: xgifb: fixed spaces coding style issue in
 vb_ext.h
In-Reply-To: <1300335784-23495-1-git-send-email-darekiwanski13@gmail.com>
Message-ID: <alpine.DEB.1.10.1103171253040.2634@esdhcp041196.research.nokia.com>
References: <1300335784-23495-1-git-send-email-darekiwanski13@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 17 Mar 2011, Darek Iwanski wrote:
> This is a patch to the vb_ext.h file that fixes up spaces warning
> found by the checkpatch.pl tool. It still has a typedef warning that I
> do not understand how to fix.

The patch is against the wrong tree, it won't apply anymore.

Anyway, all that x86 register stuff should be deleted. There should be
nothing x86 specific in this driver.

> Signed-off-by: Darek Iwanski <darekiwanski13$Gmail.com>
> ---
> drivers/staging/xgifb/vb_ext.h |   37 ++++++++++++++++++++-----------------
> 1 files changed, 20 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/staging/xgifb/vb_ext.h b/drivers/staging/xgifb/vb_ext.h
> index 5cc4d12..a3ec4ee 100644
> --- a/drivers/staging/xgifb/vb_ext.h
> +++ b/drivers/staging/xgifb/vb_ext.h
> @@ -1,34 +1,37 @@
> -#ifndef  _VBEXT_
> -#define  _VBEXT_
> +#ifndef _VBEXT_
> +#define _VBEXT_
>
> struct DWORDREGS {
> -    unsigned long    Eax, Ebx, Ecx, Edx, Esi, Edi, Ebp;
> +	unsigned long Eax, Ebx, Ecx, Edx, Esi, Edi, Ebp;
> };
>
> struct WORDREGS {
> -    unsigned short ax, hi_ax, bx, hi_bx, cx, hi_cx, dx, hi_dx, si,
> -	    hi_si, di, hi_di, bp, hi_bp;
> +	unsigned short ax, hi_ax, bx, hi_bx, cx, hi_cx, dx, hi_dx, si,
> +		hi_si, di, hi_di, bp, hi_bp;
> };
>
> struct BYTEREGS {
> -     unsigned char al, ah, hi_al, hi_ah, bl, bh, hi_bl, hi_bh, cl, ch,
> -	     hi_cl, hi_ch, dl, dh, hi_dl, hi_dh;
> +	unsigned char al, ah, hi_al, hi_ah, bl, bh, hi_bl, hi_bh, cl, ch,
> +		hi_cl, hi_ch, dl, dh, hi_dl, hi_dh;
> };
>
> -typedef union   _X86_REGS    {
> -    struct  DWORDREGS e;
> -    struct  WORDREGS x;
> -    struct  BYTEREGS h;
> +typedef union _X86_REGS {
> +	struct DWORDREGS e;
> +	struct WORDREGS x;
> +	struct BYTEREGS h;
> } X86_REGS, *PX86_REGS;
>
> -extern   void     XGI_XG21Fun14(struct xgi_hw_device_info *pXGIHWDE, PX86_REGS pBiosArguments);
> +extern void XGI_XG21Fun14(struct xgi_hw_device_info *pXGIHWDE,
> +	PX86_REGS pBiosArguments);
> extern void XGISetDPMS(struct xgi_hw_device_info *pXGIHWDE,
> -		       unsigned long VESA_POWER_STATE);
> -extern   void     XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
> -extern   void     XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
> +	unsigned long VESA_POWER_STATE);
> +extern void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
> +	struct vb_device_info *pVBInfo);
> +extern void XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension,
> +	struct vb_device_info *pVBInfo) ;
> extern void ReadVBIOSTablData(unsigned char ChipType,
> -			      struct vb_device_info *pVBInfo);
> +	struct vb_device_info *pVBInfo);
> extern unsigned short XGINew_SenseLCD(struct xgi_hw_device_info *,
> -				      struct vb_device_info *pVBInfo);
> +	struct vb_device_info *pVBInfo);
>
> #endif
> -- 
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
