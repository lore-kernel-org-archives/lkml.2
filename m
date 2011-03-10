Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab1CJPyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:54:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60641 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751310Ab1CJPyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:54:49 -0500
Date: Thu, 10 Mar 2011 15:54:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 3/4] regulator: added register initialization for
 ab8500 regulators
Message-ID: <20110310155447.GB27206@opensource.wolfsonmicro.com>
References: <1299764631-2570-1-git-send-email-linus.walleij@stericsson.com>
 <20110310135053.GF22195@opensource.wolfsonmicro.com>
 <AANLkTi=EbGiibp4hqBDKpeB4YOLFDRwtiuQyK6b190kZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=EbGiibp4hqBDKpeB4YOLFDRwtiuQyK6b190kZ@mail.gmail.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 04:49:38PM +0100, Linus Walleij wrote:

> The commit message is wrong. My bad, BTW, Bengt didn't
> write that up. What we're actually passing in from the platform
> data is stuff like this (taken from other patch):

OK, that's fine - please redo the commit message to make this clear.
