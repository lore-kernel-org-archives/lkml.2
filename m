Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1HYLhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 07:37:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40078 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753248Ab1HYLhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 07:37:17 -0400
Date: Thu, 25 Aug 2011 12:37:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110825113715.GA2061@opensource.wolfsonmicro.com>
References: <20110823151936.GM9232@opensource.wolfsonmicro.com>
 <201108232351.55432.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108232351.55432.rjw@sisk.pl>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 11:51:55PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, August 23, 2011, Mark Brown wrote:

> > and the boot runs very slowly.  Reverting the series merged in 56f0be
> > appears to resolve the issue,

> In fact, the patch from:

> https://patchwork.kernel.org/patch/1083602/

> is sufficient to make the calltrace go away.

Yes, that works for me too thanks!

Tested-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
