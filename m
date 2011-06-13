Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab1FMM0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:26:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:21640 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab1FMM0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:26:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,358,1304319600"; 
   d="scan'208";a="13799688"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Kirill Smelkov <kirr@mns.spb.ru>, Greg Kroah-Hartman <gregkh@suse.de>
CC: Mike Thomas <rmthomas@sciolus.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 13 Jun 2011 15:26:39 +0300
Subject: RE: [PATCH 4/5] staging/easycap: PAGE_SIZE is always defined
Thread-Topic: [PATCH 4/5] staging/easycap: PAGE_SIZE is always defined
Thread-Index: AcwpxDF+XcnHYGcRTKOctXL8URx8RAAAOoWg
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401AD3191D1@hasmsx504.ger.corp.intel.com>
References: <cover.1307967011.git.kirr@mns.spb.ru>
 <ae1c276f60740459efdfaf57b577e57841c22683.1307967011.git.kirr@mns.spb.ru>
In-Reply-To: <ae1c276f60740459efdfaf57b577e57841c22683.1307967011.git.kirr@mns.spb.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kirill Smelkov [mailto:kirr@mns.spb.ru]
> Sent: Monday, June 13, 2011 3:19 PM
> To: Greg Kroah-Hartman
> Cc: Winkler, Tomas; Mike Thomas; devel@driverdev.osuosl.org; linux-
> kernel@vger.kernel.org; Kirill Smelkov
> Subject: [PATCH 4/5] staging/easycap: PAGE_SIZE is always defined
> 
> I'm not 100% sure, only 99.99% that PAGE_SIZE is always defined in Linux. So
> there is no need to check for it.
> 
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Cc: Mike Thomas <rmthomas@sciolus.org>
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/staging/easycap/easycap.h |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/easycap/easycap.h
> b/drivers/staging/easycap/easycap.h
> index 1f94e23..5d21620 100644
> --- a/drivers/staging/easycap/easycap.h
> +++ b/drivers/staging/easycap/easycap.h
> @@ -85,10 +85,6 @@
>  #include <linux/videodev2.h>
>  #include <linux/soundcard.h>
> 
> -#ifndef PAGE_SIZE
> -#error "PAGE_SIZE not defined"
> -#endif /* PAGE_SIZE */
> -
>  /*---------------------------------------------------------------------------*/
>  /*  VENDOR, PRODUCT:  Syntek Semiconductor Co., Ltd
>   *
> --
> 1.7.6.rc1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

