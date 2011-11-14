Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab1KNVo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 16:44:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44483 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942Ab1KNVo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 16:44:58 -0500
Date: Mon, 14 Nov 2011 21:44:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] regmap: return ERR_PTR instead of NULL in regmap_init
Message-ID: <20111114214455.GK6528@opensource.wolfsonmicro.com>
References: <1321263619-25891-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321263619-25891-1-git-send-email-lars@metafoo.de>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 10:40:15AM +0100, Lars-Peter Clausen wrote:
> The regmap_init documentation states that it will either return a pointer to a
> valid regmap structure or a ERR_PTR in case of an error. Currently it returns a
> NULL pointer in case no bus or no config was given. Since NULL is not a
> ERR_PTR a caller might assume that it is a pointer to a valid regmap structure,
> so return a ERR_PTR(-EINVAL) instead.

Applied, thanks.
