Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1A1GWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 01:22:13 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45472 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab1A1GWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 01:22:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LOXeaaHroacDNTk8uwytQjhdeHO50NNgZi3id+Uh+xsNB2vL4mxPi0p+9+HfajhJSR
         fCXV58HPZZ6hBOuoEtvhTBxFMrzVk6NO5TvpenKJ9zXoAZ3Grcg0onjz3XKIWGdlq0Rd
         5Jpg+7nnDPYvupE4ShU8qJ7LdfFimKSPhQCRM=
MIME-Version: 1.0
In-Reply-To: <d1deb8a42497651898ad03bda9018d9deca93f12.1296186677.git.joe@perches.com>
References: <cover.1296186677.git.joe@perches.com>
	<d1deb8a42497651898ad03bda9018d9deca93f12.1296186677.git.joe@perches.com>
Date: Fri, 28 Jan 2011 09:22:11 +0300
Message-ID: <AANLkTintmdzz0bha3TzfsgMut2zrzt1X5TLYWCvm9gm2@mail.gmail.com>
Subject: Re: [PATCH 05/15] staging: ath6kl: wmi.h: Convert packed structures
 with A_BOOL to u32
From: Denis Kirjanov <kirjanov@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Vipin Mehta <vmehta@atheros.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 7:04 AM, Joe Perches <joe@perches.com> wrote:
> From: Joe Perches <joe@atheros-desktop.(none)>
>
> These structures are device native and need to be 4 bytes long.
>
> Signed-off-by: Joe Perches <joe@atheros-desktop.(none)>
> ---
You should fix your email address  here

>  drivers/staging/ath6kl/include/common/wmi.h |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/staging/ath6kl/include/common/wmi.h b/drivers/staging/ath6kl/include/common/wmi.h
> index c75d310..eb8f7ba 100644
> --- a/drivers/staging/ath6kl/include/common/wmi.h
> +++ b/drivers/staging/ath6kl/include/common/wmi.h
> @@ -635,8 +635,8 @@ typedef enum {
>  } WMI_SCAN_TYPE;
>
>  typedef PREPACK struct {
> -    A_BOOL   forceFgScan;
> -    A_BOOL   isLegacy;        /* For Legacy Cisco AP compatibility */
> +    u32   forceFgScan;
> +    u32   isLegacy;        /* For Legacy Cisco AP compatibility */
>     A_UINT32 homeDwellTime;   /* Maximum duration in the home channel(milliseconds) */
>     A_UINT32 forceScanInterval;    /* Time interval between scans (milliseconds)*/
>     A_UINT8  scanType;           /* WMI_SCAN_TYPE */
> @@ -1241,7 +1241,7 @@ typedef PREPACK struct {
>  * WMI_ENABLE_RM_CMDID
>  */
>  typedef PREPACK struct {
> -        A_BOOL enable_radio_measurements;
> +        u32 enable_radio_measurements;
>  } POSTPACK WMI_ENABLE_RM_CMD;
>
>  /*
> @@ -2638,7 +2638,7 @@ typedef PREPACK struct {
>  } POSTPACK WMI_SET_KEEPALIVE_CMD;
>
>  typedef PREPACK struct {
> -    A_BOOL configured;
> +    u32 configured;
>     A_UINT8 keepaliveInterval;
>  } POSTPACK WMI_GET_KEEPALIVE_CMD;
>
> @@ -2717,8 +2717,8 @@ typedef PREPACK struct {
>  } POSTPACK WMI_SET_IP_CMD;
>
>  typedef PREPACK struct {
> -    A_BOOL awake;
> -    A_BOOL asleep;
> +    u32 awake;
> +    u32 asleep;
>  } POSTPACK WMI_SET_HOST_SLEEP_MODE_CMD;
>
>  typedef enum {
> @@ -2726,7 +2726,7 @@ typedef enum {
>  } WMI_WOW_FILTER;
>
>  typedef PREPACK struct {
> -    A_BOOL enable_wow;
> +    u32 enable_wow;
>     WMI_WOW_FILTER filter;
>     A_UINT16 hostReqDelay;
>  } POSTPACK WMI_SET_WOW_MODE_CMD;
> @@ -3010,7 +3010,7 @@ typedef PREPACK struct {
>  } POSTPACK WMI_AP_PROT_SCAN_TIME_CMD;
>
>  typedef PREPACK struct {
> -    A_BOOL flag;
> +    u32 flag;
>     A_UINT16 aid;
>  } POSTPACK WMI_AP_SET_PVB_CMD;
>
> --
> 1.7.4.rc3
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>



-- 
Regards,
Denis
