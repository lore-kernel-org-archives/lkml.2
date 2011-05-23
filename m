Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab1EWWyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:54:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34555 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab1EWWyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:54:15 -0400
Date: Mon, 23 May 2011 15:53:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, x86@kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Harald Welte <laforge@gnufiish.org>,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: linux-next: Tree for May 23 (sound/soc/codecs)
Message-Id: <20110523155343.2e68c265.randy.dunlap@oracle.com>
In-Reply-To: <20110523224659.GB19533@opensource.wolfsonmicro.com>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
	<20110523134815.fb87933a.randy.dunlap@oracle.com>
	<20110523224659.GB19533@opensource.wolfsonmicro.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4DDAE585.001C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011 06:47:28 +0800 Mark Brown wrote:

> On Mon, May 23, 2011 at 01:48:15PM -0700, Randy Dunlap wrote:
> > On Mon, 23 May 2011 15:45:18 +1000 Stephen Rothwell wrote:
> 
> > when CONFIG_GPIOLIB is not enabled
> > and CONFIG_GENERIC_GPIO is not enabled:
> 
> > sound/soc/codecs/ak4641.c:524: error: 'GPIOF_OUT_INIT_LOW' undeclared (first use in this function)
> > sound/soc/codecs/wm8915.c:2857: error: 'GPIOF_OUT_INIT_LOW' undeclared (first use in this function)
> 
> What architecture is this on (you should always include information like
> this anyway so people can try to reproduce what you're seeing)?  In any

on x86_64  [adding x86@kernel.org == arch maintainers]

> case, please talk to the architecture maintainers about this - it's an
> issue in the architecture GPIO support (or lack thereof) rather than a
> driver problem.

except that a driver should not assume that defines like
GPIOF_OUT_INIT_LOW are always available.

> Also adding Dmitry who submitted the driver - Randy, please try to
> remember to CC relevant people.

Which driver did Dmitry submit?  how would I know that?
I don't download every linux-next git tree -- just linux-next tarballs.


ak4641.c says:
MODULE_AUTHOR("Harald Welte <laforge@gnufiish.org>");
  [which bounces]

and wm8915.c says:
MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
