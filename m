Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab1EZOFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:05:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33417 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757360Ab1EZOFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:05:05 -0400
Date: Thu, 26 May 2011 22:04:51 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>,
        Cyril Chemparathy <cyril@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2] regulator: Group TI TPSxxxxx regulators together
Message-ID: <20110526140444.GA15094@opensource.wolfsonmicro.com>
References: <1306414825.4042.11.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306414825.4042.11.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 09:00:25PM +0800, Axel Lin wrote:
> Group TI TPSxxxxx regulators together and sort in alphabetical order.
> This change make it easier for users to find config options.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

I'd like to see us sort the entire Makefile and Kconfig.
