Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab0KXLhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 06:37:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53843 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753584Ab0KXLg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 06:36:59 -0500
Date: Wed, 24 Nov 2010 11:36:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/3] mfd: Added new regulator_data pointer to ab8500
 board configuration
Message-ID: <20101124113655.GC24970@rakim.wolfsonmicro.main>
References: <1290536754-21775-1-git-send-email-bengt.g.jonsson@stericsson.com>
 <1290536754-21775-2-git-send-email-bengt.g.jonsson@stericsson.com>
 <20101123183037.GA19212@rakim.wolfsonmicro.main>
 <4CECCBAE.6080707@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CECCBAE.6080707@stericsson.com>
X-Cookie: Made with real ingredients.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 09:24:14AM +0100, Bengt Jonsson wrote:

> The problem I see is that ab8500-core defines the number of
> regulators which I can see no reason for. If someone wants to add or
> remove a regulator they have to make a change in
> include/linux/mfd/ab8500.c as well as in the regulator files.

> I will add a better description in an updated patch.

Seems reasonable, though there's now an issue with the platform getting
the size of the array wrong - might be worth adding an array size for
the platform to initialise to catch that.
