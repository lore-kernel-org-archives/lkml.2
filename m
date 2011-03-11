Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab1CKPbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:31:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49098 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755563Ab1CKPbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:31:37 -0500
Date: Fri, 11 Mar 2011 15:31:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: Re: [PATCH] regulator: switch the ab3100 to use enable_time()
Message-ID: <20110311153134.GO1760@opensource.wolfsonmicro.com>
References: <1299857178-5221-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299857178-5221-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 04:26:18PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This switches the ab3100 core to use the enable_time()
> infrastructure from the regulator core.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
