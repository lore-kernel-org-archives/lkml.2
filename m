Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2AQLE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 06:04:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54469 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753303Ab2AQLE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 06:04:58 -0500
Date: Tue, 17 Jan 2012 11:04:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] regulator: Add devm_regulator_get()
Message-ID: <20120117110454.GD2944@opensource.wolfsonmicro.com>
References: <1326771598-28124-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326771598-28124-1-git-send-email-sboyd@codeaurora.org>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 07:39:58PM -0800, Stephen Boyd wrote:

> @@ -200,6 +202,11 @@ static inline struct regulator *__must_check regulator_get(struct device *dev,
>  	 */
>  	return NULL;
>  }
> +static inline struct regulator *__must_check
> +devm_regulator_get(struct device *dev, const char *id)
> +{
> +	return NULL;
> +}
>  static inline void regulator_put(struct regulator *regulator)
>  {
>  }

Oh, and it's not obvious from the diff but blank lines please like the
adjacent code.
