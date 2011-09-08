Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1IHXxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:53:51 -0400
Received: from d1.icnet.pl ([212.160.220.21]:37128 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756475Ab1IHXxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:53:46 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 3.1-rc1] ARM: entry: fix wrong parameter used in do_thumb_abort
Date: Thu, 8 Sep 2011 20:02:11 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201108241307.21056.jkrzyszt@tis.icnet.pl> <20110907114740.GS6619@n2100.arm.linux.org.uk> <201109071958.47945.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201109071958.47945.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Message-Id: <201109082002.11635.jkrzyszt@tis.icnet.pl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Sep 2011 at 19:58:47 Janusz Krzysztofik wrote:
> On Wed, 7 Sep 2011 at 13:47:40 Russell King - ARM Linux wrote:
> > On Wed, Sep 07, 2011 at 01:10:08PM +0200, Janusz Krzysztofik wrote:
> > > Any special requirements as to the process of submitting bug
> > > fixes against arch/arm common bits?
> > 
> > It needs to go into the patch system for merging so that it doesn't
> > get buried and forgotten - as already demonstrated.
> 
> Still not sure: am I suppposed to do something for the patch to go to
> the patch system? Or do you take care of this?

OK, instead of waiting for your answer, I've found an interface to your 
patch system myself and submitted the patch.

Next time, for how long after posting a patch to the linux-arm-kernel 
lists should I wait for comments before I can submit it to the patch 
system even if there are no signs of the patch being reviewed? IOW, can 
I assume you accept a patch if you don't comment it for a certain period 
of time?

Thanks,
Janusz
