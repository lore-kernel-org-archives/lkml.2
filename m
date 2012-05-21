Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab2EUJyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:54:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55092 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab2EUJyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:54:40 -0400
Date: Mon, 21 May 2012 10:54:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20120521095427.GA30045@sirena.org.uk>
References: <20120521134219.6d6396802bd6a097503bac92@canb.auug.org.au>
 <4FB9F818.4030801@linaro.org>
 <20120521184005.3b7661ec6468c5878a22615d@canb.auug.org.au>
 <4FBA0460.1070300@linaro.org>
 <20120521191007.9347651e88add2e7c247a24f@canb.auug.org.au>
 <4FBA08A4.6030706@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBA08A4.6030706@linaro.org>
X-Cookie: Do not pick the flowers.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 10:19:32AM +0100, Lee Jones wrote:
> > include/linux/mfd/abx500/ab8500-sysctrl.h:#endif /* CONFIG_AB8500_CORE */
> 
> > drivers/mfd/Makefile:obj-$(CONFIG_AB8500_CORE)  += ab8500-core.o ab8500-sysctrl.o

> So somewhere along the line an X86 config is selecting CONFIG_AB8500_CORE when it shouldn't. 

> I can't see anything relevant in my tree. I'll try to pull yours as have a look.

Since there's no dependencies which would stop it being selected
anything like allyesconfig or randconfig might enable it.  In general
it's normal to allow this in order to make it easier to build test
things like subsystem wide changes.
