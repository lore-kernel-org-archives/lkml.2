Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1CQMeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:34:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51888 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754057Ab1CQMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:34:05 -0400
Date: Thu, 17 Mar 2011 12:34:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 3/3] regulator: add ab8500 enable and raise time delays
Message-ID: <20110317123403.GE31411@opensource.wolfsonmicro.com>
References: <1300364702-27629-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300364702-27629-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 01:25:02PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This uses the new infrastructure to provide proper delays when
> enabling or setting the voltage of one specific regulator.
> 
> Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

though it seems odd that the ramp and enable times are identical.
