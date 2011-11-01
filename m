Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab1KANCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 09:02:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48204 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab1KANCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 09:02:52 -0400
Date: Tue, 1 Nov 2011 13:02:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: sameo@openedhand.com, linux-kernel@vger.kernel.org,
        Dajun <dajun.chen@diasemi.com>, linaro-dev@lists.linaro.org,
        arnd@arndb.de, eric.miao@linaro.org, sameo@linux.intel.com
Subject: Re: [PATCH 01/11] MFD: DA9052/53 MFD core module v8
Message-ID: <20111101130249.GE10029@opensource.wolfsonmicro.com>
References: <1320152142.4892.4.camel@L-0761.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320152142.4892.4.camel@L-0761.kpit.com>
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 06:25:42PM +0530, ashishj3 wrote:

> include/linux/mfd/da9052/reg.h    |  777
> +++++++++++++++++++++++++++++++++++++

Your mail is word wrapped...

> +config PMIC_DA9052
> + bool
> + select MFD_CORE

...and all the indentation is broken.
