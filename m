Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1CPL17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 07:27:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36141 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1CPL1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 07:27:55 -0400
Subject: Re: [PATCH] regulator: switch the ab3100 to use enable_time()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
In-Reply-To: <20110311153134.GO1760@opensource.wolfsonmicro.com>
References: <1299857178-5221-1-git-send-email-linus.walleij@stericsson.com>
	 <20110311153134.GO1760@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 11:27:51 +0000
Message-ID: <1300274871.3432.43.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-11 at 15:31 +0000, Mark Brown wrote:
> On Fri, Mar 11, 2011 at 04:26:18PM +0100, Linus Walleij wrote:
> > From: Linus Walleij <linus.walleij@linaro.org>
> > 
> > This switches the ab3100 core to use the enable_time()
> > infrastructure from the regulator core.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam

