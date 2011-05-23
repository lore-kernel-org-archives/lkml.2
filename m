Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab1EWWri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:47:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48194 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752875Ab1EWWrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:47:35 -0400
Date: Tue, 24 May 2011 06:47:28 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Harald Welte <laforge@gnufiish.org>,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: linux-next: Tree for May 23 (sound/soc/codecs)
Message-ID: <20110523224659.GB19533@opensource.wolfsonmicro.com>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
 <20110523134815.fb87933a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523134815.fb87933a.randy.dunlap@oracle.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 01:48:15PM -0700, Randy Dunlap wrote:
> On Mon, 23 May 2011 15:45:18 +1000 Stephen Rothwell wrote:

> when CONFIG_GPIOLIB is not enabled
> and CONFIG_GENERIC_GPIO is not enabled:

> sound/soc/codecs/ak4641.c:524: error: 'GPIOF_OUT_INIT_LOW' undeclared (first use in this function)
> sound/soc/codecs/wm8915.c:2857: error: 'GPIOF_OUT_INIT_LOW' undeclared (first use in this function)

What architecture is this on (you should always include information like
this anyway so people can try to reproduce what you're seeing)?  In any
case, please talk to the architecture maintainers about this - it's an
issue in the architecture GPIO support (or lack thereof) rather than a
driver problem.

Also adding Dmitry who submitted the driver - Randy, please try to
remember to CC relevant people.
