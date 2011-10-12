Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab1JLKOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 06:14:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46166 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512Ab1JLKOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 06:14:20 -0400
Date: Wed, 12 Oct 2011 11:14:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Liam Girdwood <lrg@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] regulator: gpio-regulator add dependency on GENERIC_GPIO
Message-ID: <20111012101417.GB3647@opensource.wolfsonmicro.com>
References: <201110112311.02195.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201110112311.02195.heiko@sntech.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 11:11:01PM +0200, Heiko Stübner wrote:
> Without GENERIC_GPIO "struct gpio" is undefined leading to errors.

Applied, thanks.
