Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab2BNA7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:59:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:53236 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab2BNA70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:59:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.3-rc4
Date: Tue, 14 Feb 2012 00:52:39 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Ryan Mallon <rmallon@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
References: <4F394D34.6000604@atmel.com>
In-Reply-To: <4F394D34.6000604@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202140052.39979.arnd@arndb.de>
X-Provags-ID: V02:K0:MUC3WQAl6qbetQfGmpZdmxlZvGHmY8pRB6Rg9DjoAs0
 RTOoN9uK3rCKaYPVCaJHwbgMD7hC8oqmK46yJnr5Dw6L5fvuum
 xsM9iCxx+Hbw7Y750wWdbIO2G9LC+46Krl09sc5aAitJwVxPoC
 nGMfnIhK6/X2fv5LjEdJzgu2Jh01XiyJOYfBQgpko12L+kYLF0
 oMswdwDwianCnHgGeqQqXLIv98jg6cxX7rtC72Hqy9wSOsAnts
 tkEvmlBlS1q8liTgHZiLkWY7aivPgnTKbcjtoppJLYF7vIAqRw
 bWL8XxsoFoJ205YasjbIwhqiVoENu55cAHwcq04WRyBUvkMonr
 TolIsdIbd+0UoDRplRCc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 February 2012, Nicolas Ferre wrote:
> Olof, Arnd,
> 
> Here is the second "fixes" pull request. It collects a simple #ifdef fix, the
> proper use of ioremap() in the RTC driver and a set of SMC related
> modifications.
> The SMC has been modified recently and has broken the pata_at91 driver. The
> new accessors are fixing this situation. Finally, the old at91_ide driver is
> removed because it is not maintained anymore, the IDE tree is frozen and PATA
> should be used instead.
> 
> I have also verified that it merges correctly with depends/rmk/for-armsoc and all
> at91 related 3.4 material...
> 
> You can find all this here:
> 
> The following changes since commit d65b4e98d7ea3038b767b70fe8be959b2913f16d:

Hmm, this is a bit bigger than I would have hoped for an -rc4 pull request.

I've applied it now to the fixes branch because it seems necessary, I hope
this doesn't come back to us in a bad way. Olof, please have a look over
these patches as well. If you're ok with these, I'll send the entire batch
to Linus.

	Arnd

