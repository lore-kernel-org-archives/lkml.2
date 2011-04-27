Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab1D0K0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:26:17 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5492 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab1D0K0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:26:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 27 Apr 2011 03:26:12 -0700
From: Wei Ni <wni@nvidia.com>
To: "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "ccross@android.com" <ccross@android.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 27 Apr 2011 18:25:51 +0800
Subject: RE: [PATCH 0/2] i2c: tegra: add some new features for tegra i2c
Thread-Topic: [PATCH 0/2] i2c: tegra: add some new features for tegra i2c
Thread-Index: Acv/U9peluMUOVgAQtuc8GIYvXxc8QFcZJpQ
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C2CB3DD4DB@HKMAIL01.nvidia.com>
References: <1303301312-15302-1-git-send-email-wni@nvidia.com>
In-Reply-To: <1303301312-15302-1-git-send-email-wni@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all
Could anyone review these changes?

Thanks
Wei.

-----Original Message-----
From: Wei Ni 
Sent: Wednesday, April 20, 2011 8:09 PM
To: khali@linux-fr.org; ben-linux@fluff.org; lucas.demarchi@profusion.mobi; ccross@android.com; linux-i2c@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: Wei Ni
Subject: [PATCH 0/2] i2c: tegra: add some new features for tegra i2c

From: Wei Ni <wni@nvidia.com>

*** BLURB HERE ***

Wei Ni (2):
  i2c: tegra: Retry transfer when unexpected/no_ack status is detected
  i2c: tegra: use new i2c slave controller

 drivers/i2c/busses/i2c-tegra.c |   57 +++++++++++++++++++++++++++++++++++++--
 include/linux/i2c-tegra.h      |    3 ++
 2 files changed, 57 insertions(+), 3 deletions(-)

