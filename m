Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab0KZPSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:18:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33888 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752937Ab0KZPSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:18:47 -0500
Date: Fri, 26 Nov 2010 15:18:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 0/7] Wolfson MFD updates
Message-ID: <20101126151845.GK30360@rakim.wolfsonmicro.main>
References: <20101124180055.GO24970@rakim.wolfsonmicro.main>
 <20101126140518.GN5520@sortiz-mobl>
 <20101126140719.GH30360@rakim.wolfsonmicro.main>
 <20101126145151.GA27663@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126145151.GA27663@sortiz-mobl>
X-Cookie: Sentient plasmoids are a gas.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 03:51:52PM +0100, Samuel Ortiz wrote:
> On Fri, Nov 26, 2010 at 02:07:19PM +0000, Mark Brown wrote:

> > Would it be OK to apply patch 7 to the ASoC tree?  There's a bunch of
> > CODEC driver changes to support the WM8958 which depend on it and also
> > depend on changes in the ASoC tree.

> Sure, I'm fine with that.

OK, I've gone ahead and done that with your ack added - thanks!
