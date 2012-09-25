Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab2IYGup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:50:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab2IYGuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:50:44 -0400
Date: Tue, 25 Sep 2012 12:20:25 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sjur BRENDELAND <sjur.brandeland@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv4] virtio_console: Add support for remoteproc serial
Message-ID: <20120925065025.GF32657@amit.redhat.com>
References: <1348489987-6768-1-git-send-email-sjur.brandeland@stericsson.com>
 <20120924174523.GA14390@amit.redhat.com>
 <81C3A93C17462B4BBD7E272753C1057923BD79D728@EXDCVYMBSTM005.EQ1STM.local>
 <20120925040158.GC32657@amit.redhat.com>
 <87sja63c9b.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sja63c9b.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 25 Sep 2012 [14:55:04], Rusty Russell wrote:
> Amit Shah <amit.shah@redhat.com> writes:
> 
> > On (Mon) 24 Sep 2012 [23:50:01], Sjur BRENDELAND wrote:
> >> Hi Amit,
> >> 
> >> > I'm sorry for not being able to look at this earlier.
> >> 
> >> No worries. I'll try to respin and retest this patch by tomorrow.
> >> If you by any chance could find time to review so could make it in time
> >> for 3.7 it would be great :-)
> >
> > I think it might be late for 3.7 already, I'd prefer to let this bake
> > for a while, ensure it passes my test suites, at the least.  But I'll
> > let Rusty take the final call.
> 
> It can make the next merge window, but it has to be done this week.
> 
> I'm only allowing it this late because it's a new driver.

It does change code shared with the 'older' console and serial ports,
so the risk of regressions does exist.

		Amit
