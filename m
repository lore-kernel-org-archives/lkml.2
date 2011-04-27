Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1D0Q3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:29:46 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4440 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1D0Q3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:29:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 27 Apr 2011 09:29:21 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Wei Ni <wni@nvidia.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "ccross@android.com" <ccross@android.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Olof Johansson (olof@lixom.net)" <olof@lixom.net>
Date: Wed, 27 Apr 2011 09:29:19 -0700
Subject: RE: [PATCH 0/2] i2c: tegra: add some new features for tegra i2c
Thread-Topic: [PATCH 0/2] i2c: tegra: add some new features for tegra i2c
Thread-Index: Acv/U9peluMUOVgAQtuc8GIYvXxc8QFcZJpQAAyVSsA=
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF0497F1AAC4@HQMAIL01.nvidia.com>
References: <1303301312-15302-1-git-send-email-wni@nvidia.com>
 <6B4D417B830BC44B8026029FD256F7F1C2CB3DD4DB@HKMAIL01.nvidia.com>
In-Reply-To: <6B4D417B830BC44B8026029FD256F7F1C2CB3DD4DB@HKMAIL01.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wei Ni wrote at Wednesday, April 27, 2011 4:26 AM:
> Hi, all
> Could anyone review these changes?

Wei,

It looks like some of the patches I recently posted address the same
issues as the patches you had already posted. Sorry for the potential
conflicts.

Can you please take a look at the patches I posted and comment on which
of those are still relevant given your patches. Even for the cases where
we both posted patches to address the same issue (e.g. use new slave
mode), there are differences in the patches. I simply took the changes
from the chromeos-2.6.37 kernel and cherry-picked them into the mainline
kernel. Are the changes you posted re-written to address issues that
weren't solved in the ChromeOS kernel?

Thanks for any feedback on this.

> 
> Thanks
> Wei.
> 
> -----Original Message-----
> From: Wei Ni
> Sent: Wednesday, April 20, 2011 8:09 PM
> To: khali@linux-fr.org; ben-linux@fluff.org;
> lucas.demarchi@profusion.mobi; ccross@android.com; linux-
> i2c@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Wei Ni
> Subject: [PATCH 0/2] i2c: tegra: add some new features for tegra i2c
> 
> From: Wei Ni <wni@nvidia.com>
> 
> *** BLURB HERE ***
> 
> Wei Ni (2):
>   i2c: tegra: Retry transfer when unexpected/no_ack status is detected
>   i2c: tegra: use new i2c slave controller
> 
>  drivers/i2c/busses/i2c-tegra.c |   57
> +++++++++++++++++++++++++++++++++++++--
>  include/linux/i2c-tegra.h      |    3 ++
>  2 files changed, 57 insertions(+), 3 deletions(-)

-- 
nvpublic

