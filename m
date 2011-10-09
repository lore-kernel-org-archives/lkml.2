Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab1JILgp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 07:36:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58015 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903Ab1JILgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 07:36:44 -0400
Date: Sun, 9 Oct 2011 12:36:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regulator: Add driver for gpio-controlled regulators
Message-ID: <20111009113642.GA20037@opensource.wolfsonmicro.com>
References: <201110051227.05717.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201110051227.05717.heiko@sntech.de>
X-Cookie: Chicken Little was right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 12:27:05PM +0200, Heiko Stübner wrote:
> This patch adds support for regulators that can be controlled via gpios.
> 
> Examples for such regulators are the TI-tps65024x voltage regulators
> with 4 fixed and 1 runtime-switchable voltage regulators
> or the TI-bq240XX charger regulators.

Applied, thanks.
