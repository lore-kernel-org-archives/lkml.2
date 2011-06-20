Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1FTKen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:34:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58370 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753692Ab1FTKem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:34:42 -0400
Date: Mon, 20 Jun 2011 11:34:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Subject: Re: [PATCH] regulator: max8997: remove dependency on platform_data
 pointer
Message-ID: <20110620103439.GF31864@opensource.wolfsonmicro.com>
References: <1308558617-20581-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308558617-20581-1-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 05:30:17PM +0900, MyungJoo Ham wrote:
> The platform_data (pdata) may be pointing to __initdata section, which
> may be free'd from the memory. The dependency on pdata in non-init
> functions is removed in this patch to allow platform to declare
> __initdata for platform data.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
