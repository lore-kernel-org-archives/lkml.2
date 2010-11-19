Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab0KSRHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:07:12 -0500
Received: from mail.perches.com ([173.55.12.10]:1578 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788Ab0KSRHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:07:11 -0500
Subject: Re: [PATCH 1/2] drivers: regulator: core: use pr_fmt
From: Joe Perches <joe@perches.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
        bleong@codeaurora.org
In-Reply-To: <1290164963.3276.2.camel@odin>
References: <1290036628-9928-1-git-send-email-dwalker@codeaurora.org>
	 <20101118103530.GA7233@rakim.wolfsonmicro.main>
	 <1290164963.3276.2.camel@odin>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 09:07:09 -0800
Message-ID: <1290186429.28541.3.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 11:09 +0000, Liam Girdwood wrote:
> On Thu, 2010-11-18 at 10:35 +0000, Mark Brown wrote:
> > On Wed, Nov 17, 2010 at 03:30:27PM -0800, Daniel Walker wrote:
> > > This adds a pr_fmt line which uses the __func__ macro. I also
> > > convert the current pr_ lines to remove their __func__ usage.
> > > Cc: bleong@codeaurora.org
> > > Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
> > Both patches
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Applied with some merge fixups. 
> Joe, I'd be happy to take any subsequent patches you have for this.

After these patches show up in -next.

I think there were some other patches about
as well, so maybe in a week or so.

