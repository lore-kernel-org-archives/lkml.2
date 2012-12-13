Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab2LMI7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 03:59:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57814 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348Ab2LMI7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 03:59:46 -0500
Date: Thu, 13 Dec 2012 08:59:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Axel Lin <axel.lin@ingics.com>, Pawel Moll <pawel.moll@arm.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Kevin Liu <keyuan.liu@gmail.com>
Subject: Re: [PATCH RFC/RFT] regulator: core: Fix continuous_voltage_range
	case in regulator_can_change_voltage
Message-ID: <20121213085944.GH27624@opensource.wolfsonmicro.com>
References: <1355275366.11924.2.camel@phoenix> <50C99839.1040803@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C99839.1040803@samsung.com>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 09:56:25AM +0100, Marek Szyprowski wrote:

> This change looks reasonable, I've missed the fact that there is a
> support for regulators with continuous voltage range. This change also
> shows that the n_voltages based workaround used earlier by mmc core was
> indeed only a hack and regulator_can_change_voltage() approach is much
> cleaner 

Both changes are new for v3.8 so it's not surprising that you missed the
continuous regulators.
