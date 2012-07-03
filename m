Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab2GCWnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:43:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55584 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756395Ab2GCWnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:43:18 -0400
Date: Tue, 3 Jul 2012 23:43:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix recursive mutex lockdep warning
Message-ID: <20120703224316.GB11368@opensource.wolfsonmicro.com>
References: <1341282066-15325-1-git-send-email-sboyd@codeaurora.org> <20120703192652.GH29030@opensource.wolfsonmicro.com> <4FF3514E.6050401@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF3514E.6050401@codeaurora.org>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 01:08:46PM -0700, Stephen Boyd wrote:
> On 07/03/12 12:26, Mark Brown wrote:

> > Applied, thanks.  Though we should probably just remove the optimal mode
> > stuff on account of the total absence of any users...

> Please don't remove it. We use the optimal stuff fairly often
> internally, plus our usb driver is upstream and using the API.

>From what I remember there's a fair bit of non-upstream code you guys
have for regulators...  your usage is certainly very unusual.

> What do you think about removing the locking in get_voltage? Is that better?

There's already an unlocked version of get_voltage()?
