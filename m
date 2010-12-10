Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab0LJMg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 07:36:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55785 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755735Ab0LJMgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 07:36:25 -0500
Date: Fri, 10 Dec 2010 12:36:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 9/9] mach-ux500: Updated and connected ab8500 regulator
 board configuration
Message-ID: <20101210123635.GI2518@opensource.wolfsonmicro.com>
References: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
 <1291975728-12525-10-git-send-email-bengt.g.jonsson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291975728-12525-10-git-send-email-bengt.g.jonsson@stericsson.com>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 11:08:48AM +0100, Bengt Jonsson wrote:
> The ab8500 regulator board configuration is updated and put in an
> array which can easily be used in the MFD board configuration. The
> regulator board configuration is also added to the MFD
> configuration in this patch.

Acked-by: Mark Brown <broonie@opensource.wolfosnmicro.com>
