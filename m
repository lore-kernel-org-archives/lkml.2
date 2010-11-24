Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0KXKsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:48:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39254 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753378Ab0KXKsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:48:53 -0500
Date: Wed, 24 Nov 2010 10:48:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/3] regulators: Update of ab8500 driver
Message-ID: <20101124104851.GA24970@rakim.wolfsonmicro.main>
References: <1290536754-21775-1-git-send-email-bengt.g.jonsson@stericsson.com>
 <1290536754-21775-3-git-send-email-bengt.g.jonsson@stericsson.com>
 <20101123183833.GB19212@rakim.wolfsonmicro.main>
 <4CECC555.8060408@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CECC555.8060408@stericsson.com>
X-Cookie: Made with real ingredients.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 08:57:09AM +0100, Bengt Jonsson wrote:

> Removing the macros is just my suggestion. The disadvantage I see
> with macros is that I need to read both the macro and the listing to
> see what it really does. On the other hand, macros are probably more

A line of comment at the top of the macro table would probably address
that?
