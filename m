Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab0CTANv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 20:13:51 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47537 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751942Ab0CTANt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 20:13:49 -0400
Date: Sat, 20 Mar 2010 01:13:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sankar P <sankar.curiosity@gmail.com>
Cc: gregkh@suse.de, penberg@cs.helsinki.fi, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging: winbond: Convert typedef struct _PMKID to
	struct pmkid
Message-ID: <20100320001335.GB1477@ucw.cz>
References: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-2-git-send-email-sankar.curiosity@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269031264-2327-2-git-send-email-sankar.curiosity@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-03-20 02:10:59, Sankar P wrote:
> This patch converts the definition typedef struct _PMKID to
> struct pmkid and also the part where the typedef was used.
> 
> Signed-off-by: Sankar P <sankar.curiosity@gmail.com>

ACK.

> ---
>  drivers/staging/winbond/mac_structures.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
> index 0d16196..ad19c88 100644
> --- a/drivers/staging/winbond/mac_structures.h
> +++ b/drivers/staging/winbond/mac_structures.h
> @@ -505,10 +505,10 @@ struct RSN_Capability_Element
>  }__attribute__ ((packed)) ;
>  
>  #ifdef _WPA2_
> -typedef struct _PMKID
> +struct pmkid
>  {
>    u8 pValue[16];
> -}PMKID;
> +};
>  
>  struct	WPA2_RSN_Information_Element
>  {
> @@ -531,7 +531,7 @@ struct WPA2_RSN_Auth_Sub_Information_Element
>  struct PMKID_Information_Element
>  {
>  	u16				PMKID_Count;
> -	PMKID pmkid [16] ;
> +	struct pmkid pmkid[16];
>  }__attribute__ ((packed));
>  
>  #endif //enddef _WPA2_

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
