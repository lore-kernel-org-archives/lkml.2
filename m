Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab1LEQXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 11:23:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41728 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932447Ab1LEQXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 11:23:35 -0500
Date: Mon, 5 Dec 2011 16:23:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rdunlap@xenotime.net, thomas.abraham@linaro.org
Subject: Re: [PATCH] Documentation: Fix regulator_register() API signature
Message-ID: <20111205162333.GX11150@opensource.wolfsonmicro.com>
References: <1323069462-8490-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323069462-8490-1-git-send-email-rnayak@ti.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 12:47:42PM +0530, Rajendra Nayak wrote:
> The commit 2c043bcbf287 ("regulator: pass additional of_node to
> regulator_register()") added an additional parameter to the
> regulator_register() API.
> Update the Documentation accordingly to reflect the change
> in the function signature.

Applied, thanks.
