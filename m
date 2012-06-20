Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2FTDvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 23:51:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49998 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab2FTDvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 23:51:40 -0400
Date: Tue, 19 Jun 2012 20:49:49 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Pritesh Raithatha <praithatha@nvidia.com>, axel.lin@gmail.com,
        cabarnes@indesign-llc.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio-charger: use cansleep version of gpio_set_value
Message-ID: <20120620034948.GB21104@lizard>
References: <1337676604-22836-1-git-send-email-praithatha@nvidia.com>
 <4FBB6AC7.8040303@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FBB6AC7.8040303@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 12:30:31PM +0200, Lars-Peter Clausen wrote:
> On 05/22/2012 10:50 AM, Pritesh Raithatha wrote:
> > Context of gpio_charger_get_property is sleepable so we should
> > use gpio_set_value_cansleep instead of gpio_set_value.
> > 
> > It will remove WARN_ON incase of using gpio from i2c-to-gpio
> > expander like pca953x.
> > 
> > Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
> 
> Looks good,
> 
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
