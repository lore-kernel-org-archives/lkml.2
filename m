Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab1FMMZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:25:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:25466 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab1FMMZF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:25:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,358,1304319600"; 
   d="scan'208";a="13798855"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Kirill Smelkov <kirr@mns.spb.ru>, Greg Kroah-Hartman <gregkh@suse.de>
CC: Mike Thomas <rmthomas@sciolus.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 13 Jun 2011 15:24:58 +0300
Subject: RE: [PATCH 1/5] staging/easycap: Kill leftover build options in
 readme
Thread-Topic: [PATCH 1/5] staging/easycap: Kill leftover build options in
 readme
Thread-Index: AcwpxCup/h6c1SodRdq3TR+BXsNeQwAAKXaw
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401AD3191CB@hasmsx504.ger.corp.intel.com>
References: <cover.1307967011.git.kirr@mns.spb.ru>
 <0357ebaecb3c8c17cf7a8925daeed50409c11b63.1307967011.git.kirr@mns.spb.ru>
In-Reply-To: <0357ebaecb3c8c17cf7a8925daeed50409c11b63.1307967011.git.kirr@mns.spb.ru>
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
> Subject: [PATCH 1/5] staging/easycap: Kill leftover build options in readme
> 
> The following options were removed from in-tree driver, but were left in
> README:
> 
> - EASYCAP_IS_VIDEODEV_CLIENT was removed in cb81fa07
> (staging/easycap:
>   kill EASYCAP_IS_VIDEODEV_CLIENT compilation conditional);
> 
> - EASYCAP_NEEDS_V4L2_DEVICE_H/EASYCAP_NEEDS_V4L2_FOPS were
> removed in
>   30516058 (staging/easycap: kill EASYCAP_NEEDS_V4L2_DEVICE_H and
>   EASYCAP_NEEDS_V4L2_FOPS);
> 
> - EASYCAP_NEEDS_UNLOCKED_IOCTL was removed in f2b3c685
> (staging/easycap:
>   kill EASYCAP_NEEDS_UNLOCKED_IOCTL).
> 
> Remove them.
> 
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Cc: Mike Thomas <rmthomas@sciolus.org>
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>

> ---
>  drivers/staging/easycap/README |   22 ----------------------
>  1 files changed, 0 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/staging/easycap/README
> b/drivers/staging/easycap/README index 6b5ac0d..16b8264 100644
> --- a/drivers/staging/easycap/README
> +++ b/drivers/staging/easycap/README
> @@ -27,28 +27,6 @@ BUILD OPTIONS AND DEPENDENCIES  Unless
> EASYCAP_DEBUG is defined during compilation it will not be possible  to
> select a debug level at the time of module installation.
> 
> -If the parameter EASYCAP_IS_VIDEODEV_CLIENT is undefined during
> compilation -the built module is entirely independent of the videodev
> module, and when -the EasyCAP is physically plugged into a USB port the
> special files
> -/dev/easycap0 and /dev/easysnd1 are created as video and sound sources -
> respectively.
> -
> -If the parameter EASYCAP_IS_VIDEODEV_CLIENT is defined during
> compilation -the built easycap module is configured to register with the
> videodev module, -in which case the special files created when the EasyCAP
> is plugged in are
> -/dev/video0 and /dev/easysnd0.
> -
> -During in-tree builds the following should should be defined whenever the -
> parameter EASYCAP_IS_VIDEODEV_CLIENT is defined:
> -
> -EASYCAP_NEEDS_V4L2_DEVICE_H
> -EASYCAP_NEEDS_V4L2_FOPS
> -EASYCAP_NEEDS_UNLOCKED_IOCTL
> -
> -If the build is performed out-of-tree against older kernels the parameters -
> to be defined depend on the kernel version in a way which will not be -
> discussed here.
> -
> 
>  KNOWN RUNTIME ISSUES
>  --------------------
> --
> 1.7.6.rc1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

