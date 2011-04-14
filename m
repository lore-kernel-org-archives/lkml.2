Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab1DNNSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 09:18:20 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:28350 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab1DNNST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 09:18:19 -0400
X-MDAV-Processed: mail.academy.zt.ua, Thu, 14 Apr 2011 16:18:20 +0300
X-Spam-Processed: mail.academy.zt.ua, Thu, 14 Apr 2011 16:18:19 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-Return-Path: george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, Russell King <rmk@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arend van Spriel <arend@broadcom.com>,
        Jonas Gorski <jonas.gorski@gmail.com>, b43-dev@lists.infradead.org,
        Greg KH <greg@kroah.com>, Andy Botting <andy@andybotting.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <BANLkTinu+Q367oqQPiUehPcbMs-SBxbwFg@mail.gmail.com>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
	 <1302781431.21145.6.camel@dev.znau.edu.ua>
	 <BANLkTinvpt5vs+rXd3WN-a2JpGtTV+=Gyg@mail.gmail.com>
	 <4DA6E9BD.3090404@hauke-m.de>
	 <BANLkTinu+Q367oqQPiUehPcbMs-SBxbwFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 14 Apr 2011 16:15:00 +0300
Message-Id: <1302786900.21965.52.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> W dniu 14 kwietnia 2011 14:34 użytkownik Hauke Mehrtens
> <hauke@hauke-m.de> napisał:
> > On 04/14/2011 02:04 PM, Rafał Miłecki wrote:
> >> Hauke: you were proposing integrating with drivers/amba. I really
> >> expect you to comment on this, please tell us how do you see this now,
> >> when we have better overview. I took your proposal seriously, you can
> >> see the results above.
> >
> > I had no closer look at drivers/amba and this bus driver, I just saw
> > that there was a discussion about drivers/amba and this implementation
> > with no result. When the Bradcom cores are not directly connected to
> > AMBA, but are using some sort of wrapper and there are no benefits in
> > using drivers/amba, just leave it.
> >
> > As the implementation of the Braodcom AIX Bus contains some Broadcom
> > extensions and there seams to be no normal AMBA device being connected
> > to some Broadcom devices with this special interface number 3) "Broadcom
> > specific bus (bcmai)" seams to the the best approach in my opinion.
> 
> Thanks for commenting.
> 
> Russell: you were asking:
> > What does this do which the 'amba' bus support doesn't?
> I believe I explained it well in this thread. Do you still think about
> using amba/driver? Do you think we should use it?
> 
> Arnd: I found you saying:
> > I believe the one thing we really want from this driver is the bus
> > scan code, which is not present in the amba bus implementation,
> I explained how it works, I believe scanning (EPROM in this case) it
> Broadcom specific, not really AMBA standard. How do you see it?
> 
It might not Broadcom specific as EPROM core seems to be CoreLink one
core and maybe is arm-developed. But it isn't documented publicly and we
don't know yet if it is obligatory for all amba (or at least axi)
interconnects or not.

Have nice day,
George


