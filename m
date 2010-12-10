Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0LJKwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:52:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59246 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752279Ab0LJKwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:52:15 -0500
Date: Fri, 10 Dec 2010 10:52:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/9] regulators: Moved define for number of regulators
 in ab8500
Message-ID: <20101210105213.GB3200@rakim.wolfsonmicro.main>
References: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
 <1291975728-12525-2-git-send-email-bengt.g.jonsson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291975728-12525-2-git-send-email-bengt.g.jonsson@stericsson.com>
X-Cookie: Well thaaaaaaat's okay.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 11:08:40AM +0100, Bengt Jonsson wrote:
> The define for number of regulators is moved from ab8500-core to
> ab8500-regulator so that the regulator driver can be updated
> independently of ab8500-core. This also changes the platform
> configuration structure of ab8500-core so that it contains a
> pointer to the regulator_init_data array plus number of
> regulators instead of an fixed size array of pointers to
> regulator_init_data.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
