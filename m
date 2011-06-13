Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab1FMM0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:26:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:14186 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab1FMM0a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:26:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,358,1304319600"; 
   d="scan'208";a="13799504"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Kirill Smelkov <kirr@mns.spb.ru>, Greg Kroah-Hartman <gregkh@suse.de>
CC: Mike Thomas <rmthomas@sciolus.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 13 Jun 2011 15:26:17 +0300
Subject: RE: [PATCH 3/5] staging/easycap: There is no need to support V4L1
 ioctls
Thread-Topic: [PATCH 3/5] staging/easycap: There is no need to support V4L1
 ioctls
Thread-Index: AcwpxDADHlGRopC+TsOZAwW0vg2SKgAAN5Jg
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401AD3191D0@hasmsx504.ger.corp.intel.com>
References: <cover.1307967011.git.kirr@mns.spb.ru>
 <b086aa757c64aee349cea66cb652f6d4f333b50c.1307967011.git.kirr@mns.spb.ru>
In-Reply-To: <b086aa757c64aee349cea66cb652f6d4f333b50c.1307967011.git.kirr@mns.spb.ru>
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
> Subject: [PATCH 3/5] staging/easycap: There is no need to support V4L1 ioctls
> 
> Because V4L1 was completly removed from the kernel in 2.6.38. See e.g.
> 
> 08af245d ([media] V4L: remove V4L1 compatibility mode).
> 
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Cc: Mike Thomas <rmthomas@sciolus.org>
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/staging/easycap/README |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/easycap/README
> b/drivers/staging/easycap/README index cd55eea..08f649d 100644
> --- a/drivers/staging/easycap/README
> +++ b/drivers/staging/easycap/README
> @@ -106,8 +106,6 @@ hardware, but as yet it has actually been tested on
> only a few of these.
>  I have been unable to test and calibrate the S-video input myself because I
> do not possess any equipment with S-video output.
> 
> -This driver does not understand the V4L1 IOCTL commands.
> -
> 
>  UDEV RULES
>  ----------
> --
> 1.7.6.rc1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

