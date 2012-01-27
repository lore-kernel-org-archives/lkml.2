Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2A0Kei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:34:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58523 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758Ab2A0Keh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:34:37 -0500
Date: Fri, 27 Jan 2012 10:34:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Add empty devm_regulator_bulk_get for
 !CONFIG_REGULATOR
Message-ID: <20120127103434.GA32008@opensource.wolfsonmicro.com>
References: <1327640128.9868.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327640128.9868.1.camel@phoenix>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 12:55:28PM +0800, Axel Lin wrote:
> This fixes below build error if CONFIG_REGULATOR is disabled.

Weird, I somehow managed to avoid checking that in to the commit though
it's in my tree.  Anyway, applied - thanks.
