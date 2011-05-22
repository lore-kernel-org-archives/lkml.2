Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab1EVWqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 18:46:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54923 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755564Ab1EVWqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 18:46:30 -0400
Date: Mon, 23 May 2011 06:46:25 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        linux-kernel@vger.kernel.org, lrg@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>, grant.likely@secretlab.ca
Subject: Re: [PATCHv2 5/5] TPS65911: Comparator: Add comparator driver
Message-ID: <20110522224624.GB15858@opensource.wolfsonmicro.com>
References: <A9ADABDA-9D43-44CC-92D8-113C42AA5EE0@slimlogic.co.uk>
 <20110513165931.GK8970@sortiz-mobl>
 <20110514222944.GD21792@opensource.wolfsonmicro.com>
 <20110522204056.GH18610@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110522204056.GH18610@sortiz-mobl>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 10:40:57PM +0200, Samuel Ortiz wrote:
> On Sat, May 14, 2011 at 03:29:45PM -0700, Mark Brown wrote:

> > It's measuring rather than producing.
> Sure, but I still don't see how it belongs to drivers/mfd/.

It doesn't, that was my point about presenting a generic API for this.
It's just ending up in drivers/mfd for want of a better place to put it.
