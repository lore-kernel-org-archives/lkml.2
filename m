Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab1CNSPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 14:15:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54491 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754711Ab1CNSPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 14:15:34 -0400
Date: Mon, 14 Mar 2011 18:15:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: Re: [PATCH] regulator: switch the ab3100 to use enable_time()
Message-ID: <20110314181531.GA32434@opensource.wolfsonmicro.com>
References: <1299857178-5221-1-git-send-email-linus.walleij@stericsson.com>
 <20110311153134.GO1760@opensource.wolfsonmicro.com>
 <AANLkTinD9fO9Tyft0CQABMea2SbcHexNmYT9_ND_Yb-M@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinD9fO9Tyft0CQABMea2SbcHexNmYT9_ND_Yb-M@mail.gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 05:42:28PM +0100, Linus Walleij wrote:

> Mark can you pick this into the regulator tree? I have sent my ux500
> tree upstream.

No, I can't do that - mostly because Liam manages the regulator tree and
not me :)
