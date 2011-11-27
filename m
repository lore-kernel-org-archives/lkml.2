Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab1K0LZQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 06:25:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57205 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841Ab1K0LZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 06:25:15 -0500
Date: Sun, 27 Nov 2011 11:25:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>,
        Clifton Barnes <cabarnes@indesign-llc.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Nithish Mahalingam <nithish.mahalingam@intel.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Balaji Rao <balajirrao@openmoko.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH] power_supply: convert drivers/power/* to use
 module_platform_driver()
Message-ID: <20111127112512.GD2896@opensource.wolfsonmicro.com>
References: <1322280070.6458.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322280070.6458.1.camel@phoenix>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 12:01:10PM +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/power/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
