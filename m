Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab1IBG2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 02:28:38 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:14227 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933128Ab1IBG2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 02:28:35 -0400
Date: Fri, 2 Sep 2011 08:28:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Randy Dunlap <rdunlap@xenotime.net>,
        Ben Dooks <ben-linux@fluff.org>, linux-doc@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: remove deprecated callbacks
Message-ID: <20110902082813.310454af@endymion.delvare>
In-Reply-To: <1314919458.4145.23.camel@pasglop>
References: <1314852027-9523-1-git-send-email-xiyou.wangcong@gmail.com>
	<20110901105226.0d8dd8b2@endymion.delvare>
	<1314919458.4145.23.camel@pasglop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Sep 2011 09:24:18 +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2011-09-01 at 10:52 +0200, Jean Delvare wrote:
> > Furthermore, you didn't even check if the deprecated callbacks were
> > still in use. It turns out that there are 9 drivers still using one of
> > them (6 macintosh drivers and 3 sound drivers) so plain removing it
> > will cause build breakages. We obviously don't want to do that, so I am
> > not going to apply your patch (nor mine) for now.
> > 
> > I know that Benjamin Herrenschmidt is working on converting (some of)
> > the macintosh drivers. I don't have any news for some time though. Ben,
> > are you done with the conversion by now? It would be great to get it
> > merged in kernel 3.2.
> 
> I'm just bogged down by too many things, including quite a bit of travel
> lately. I have some mostly untested patches converting part of windfarm
> (not all of it yet), and therm_adt746x and a patch to add the generic
> code to register i2c devices from device-tree properly on powermacs.
> 
> I'm missing a couple more drivers & bits of windfarm and therm_pm72
> which I'd like to use the opportunity to convert into a windfarm module.
> 
> Then there's some sound drivers etc...
> 
> I am travelling again tomorrow for 2 weeks, and after that a month in
> europe, tho I'll have 10 days in the middle where I _might_ be able to
> make progress on that. Else it will have to wait for november.

Thanks for the update, Ben. November is totally fine with me, the i2c
subsystem conversion started 5 years ago or so, we can wait a couple
additional months ;) I definitely prefer that you take the time to do
it properly and we can apply the same for the remaining drivers.

If you want, we may be able to spend half an hour face to face in
Prague in October to check what you've done and if there are blocking
issues remaining.

-- 
Jean Delvare
