Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab2LFGSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 01:18:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43342 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845Ab2LFGS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 01:18:28 -0500
Date: Thu, 6 Dec 2012 15:18:21 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Chris Ball <cjb@laptop.org>, Kevin Liu <keyuan.liu@gmail.com>
Subject: Re: [PATCH 1/3] regulators: add regulator_can_change_voltage()
 function
Message-ID: <20121206061819.GE10867@opensource.wolfsonmicro.com>
References: <1354629663-29091-1-git-send-email-m.szyprowski@samsung.com>
 <1354629663-29091-2-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354629663-29091-2-git-send-email-m.szyprowski@samsung.com>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 03:01:01PM +0100, Marek Szyprowski wrote:
> Introduce a regulator_can_change_voltage() function for the subsytems or
> drivers which might check if applying voltage change is possible and use
> special workaround code when the driver is used with fixed regulators or
> regulators with disabled ability to change the voltage.

Applied, thanks.  I've put it on a topic branch and will push a signed
tag called can-change-voltage or similar as soon as I can, feel free to
merge elsewhere (ideally the signed tag).
