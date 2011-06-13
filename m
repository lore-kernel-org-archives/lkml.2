Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1FMM0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:26:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:41123 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab1FMM0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:26:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,358,1304319600"; 
   d="scan'208";a="15599095"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Kirill Smelkov <kirr@mns.spb.ru>, Greg Kroah-Hartman <gregkh@suse.de>
CC: Mike Thomas <rmthomas@sciolus.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 13 Jun 2011 15:25:47 +0300
Subject: RE: [PATCH 2/5] staging/easycap: Fix thinko in "bars" module option
 description
Thread-Topic: [PATCH 2/5] staging/easycap: Fix thinko in "bars" module
 option description
Thread-Index: AcwpxC8XGpO2woBiQpqqsx0j42TBjQAAMvYw
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401AD3191CE@hasmsx504.ger.corp.intel.com>
References: <cover.1307967011.git.kirr@mns.spb.ru>
 <14c0e4d0bb7ef1a05b9dcc14b2b51c706f844655.1307967011.git.kirr@mns.spb.ru>
In-Reply-To: <14c0e4d0bb7ef1a05b9dcc14b2b51c706f844655.1307967011.git.kirr@mns.spb.ru>
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
> Sent: Monday, June 13, 2011 3:18 PM
> To: Greg Kroah-Hartman
> Cc: Winkler, Tomas; Mike Thomas; devel@driverdev.osuosl.org; linux-
> kernel@vger.kernel.org; Kirill Smelkov
> Subject: [PATCH 2/5] staging/easycap: Fix thinko in "bars" module option
> description
> 
> Both bars=0 and bars=1 were described as meaning to display bars on signal
> lost. Actually bars=1 means "display bars", but bars=0 means display raw
> source as is (usually black screen).
> 
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Cc: Mike Thomas <rmthomas@sciolus.org>
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>


Acked-by: Tomas Winkler <tomas.winkler@intel.com>

> ---
>  drivers/staging/easycap/README |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/easycap/README
> b/drivers/staging/easycap/README index 16b8264..cd55eea 100644
> --- a/drivers/staging/easycap/README
> +++ b/drivers/staging/easycap/README
> @@ -60,7 +60,7 @@ Three module parameters are defined:
> 
>  debug      the easycap module is configured at diagnostic level n (0 to 9)
>  gain       audio gain level n (0 to 31, default is 16)
> -bars       0 =>  testcard bars when incoming video signal is lost
> +bars       0 =>  no testcard bars when incoming video signal is lost
>             1 =>  testcard bars when incoming video signal is lost (default)
> 
> 
> --
> 1.7.6.rc1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

