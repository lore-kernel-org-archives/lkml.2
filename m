Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab1CJNuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:50:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33476 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750931Ab1CJNuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:50:55 -0500
Date: Thu, 10 Mar 2011 13:50:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3/4] regulator: added register initialization for
 ab8500 regulators
Message-ID: <20110310135053.GF22195@opensource.wolfsonmicro.com>
References: <1299764631-2570-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299764631-2570-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 02:43:51PM +0100, Linus Walleij wrote:
> From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> 
> The regulators can come up in a number of undefined
> states, depending on boot path, firmware revisions and
> things like kexec():ing into a new kernel. Provide a
> platform initialization vector so that we have a known
> state when we have booted the kernel.

This should be done using the regulator constraints, there's nothing
device specific about this.
