Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783Ab2HJKFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 06:05:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56537 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759362Ab2HJKFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 06:05:49 -0400
Date: Fri, 10 Aug 2012 11:05:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] regulator: core: Add checking n_voltages if using
 list_voltage() to read voltage regulators
Message-ID: <20120810100547.GG24328@opensource.wolfsonmicro.com>
References: <1344562353.2996.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344562353.2996.1.camel@phoenix>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 09:32:33AM +0800, Axel Lin wrote:
> Use list_voltage() to read single voltage regulators should be only applied to
> single voltage regulators, thus add checking n_voltages for this case.

We should be failing to register these regulators in the first place, or
at least complaining extremely loudly about them.
