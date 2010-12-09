Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab0LIWYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:24:42 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56879 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab0LIWYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:24:41 -0500
Subject: Re: [PATCH 1/2] Change the register name definitions for mc13783
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Yong Shen <yong.shen@linaro.org>
Cc: List Linux Arm Kernel <linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=L0fXFnF2-u+zdObs56h-FYgedhe0adxOAuCq=@mail.gmail.com>
References: <AANLkTi=L0fXFnF2-u+zdObs56h-FYgedhe0adxOAuCq=@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 22:24:35 +0000
Message-ID: <1291933475.3271.211.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 18:43 +0800, Yong Shen wrote:
> Hi there,
> 
> Please give comments inline and use attached patch for testing.
> 
> Thanks
> Yong
> 
> >From e112153c6f03b49c229a8e3913a0c0459245df20 Mon Sep 17 00:00:00 2001
> From: Yong Shen <yong.shen@linaro.org>
> Date: Thu, 2 Dec 2010 14:17:02 +0800
> Subject: [PATCH 1/2] Change the register name definitions for mc13783
> 
> To make mc13783 and mc13892 share code, the register names should be
> changed to fit the new macro definitions in the comming patch.

I've just tried to apply this patch and looks like your mailer has
mangled parts of it. I repaired it and sadly it still does not apply
against the regulator tree.

git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git #for-next

Can you redo, add the acks received and resubmit.

Thanks

Liam 

