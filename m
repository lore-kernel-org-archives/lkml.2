Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0CTAOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 20:14:20 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47548 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752485Ab0CTAOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 20:14:16 -0400
Date: Sat, 20 Mar 2010 01:14:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sankar P <sankar.curiosity@gmail.com>
Cc: gregkh@suse.de, penberg@cs.helsinki.fi, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] staging: winbond: Remove unused enum
	enum_PowerManagementMode
Message-ID: <20100320001404.GC1477@ucw.cz>
References: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-2-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-3-git-send-email-sankar.curiosity@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269031264-2327-3-git-send-email-sankar.curiosity@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-03-20 02:11:00, Sankar P wrote:
> Signed-off-by: Sankar P <sankar.curiosity@gmail.com>

ACK.

> ---
>  drivers/staging/winbond/mac_structures.h |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
> index ad19c88..7eb0e57 100644
> --- a/drivers/staging/winbond/mac_structures.h
> +++ b/drivers/staging/winbond/mac_structures.h
> @@ -116,13 +116,6 @@
>  #define WLAN_MAX_PAIRWISE_CIPHER_SUITE_COUNT    ((u16) 6)
>  #define WLAN_MAX_AUTH_KEY_MGT_SUITE_LIST_COUNT  ((u16) 2)
>  
> -//========================================================
> -typedef enum enum_PowerManagementMode
> -{
> -    ACTIVE = 0,
> -    POWER_SAVE
> -} WB_PM_Mode, *PWB_PM_MODE;
> -
>  //===================================================================
>  //  Reason Code (Table 18): indicate the reason of DisAssoc, DeAuthen
>  //  length of ReasonCode is 2 Octs.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
