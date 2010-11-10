Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab0KJRNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:13:24 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:36317 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757174Ab0KJRNW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:13:22 -0500
From: Carmine IASCONE <carmine.iascone@st.com>
To: Greg KH <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>
Cc: Matteo DAMENO <matteo.dameno@st.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mems applications <mems.applications@st.com>
Date: Wed, 10 Nov 2010 18:12:49 +0100
Subject: RE: [PATCH] staging: lis331dlh: add lis331dlh driver
Thread-Topic: [PATCH] staging: lis331dlh: add lis331dlh driver
Thread-Index: AcuA8xS62f5bGeL2S1mr+EMPQyv1EwABptZg
Message-ID: <3B4B64FC2A10C148B521CFCC54F4F7E49FA33DB247@SAFEX1MAIL3.st.com>
References: <1289323527-5501-1-git-send-email-carmine.iascone@st.com>
 <20101109173540.GA20370@suse.de>
 <3B4B64FC2A10C148B521CFCC54F4F7E49FA33DB115@SAFEX1MAIL3.st.com>
 <4CDAB795.5080607@gmail.com> <20101110160412.GB10561@suse.de>
In-Reply-To: <20101110160412.GB10561@suse.de>
Accept-Language: it-IT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: it-IT, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks you both for the feedback.

Best regards,
Carmine

-----Original Message-----
From: Greg KH [mailto:gregkh@suse.de] 
Sent: Wednesday, November 10, 2010 5:04 PM
To: Carmine IASCONE
Cc: Jiri Slaby; Matteo DAMENO; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; mems applications; Alan Cox
Subject: Re: [PATCH] staging: lis331dlh: add lis331dlh driver

On Wed, Nov 10, 2010 at 04:17:41PM +0100, Jiri Slaby wrote:
> On 11/10/2010 12:51 PM, Carmine IASCONE wrote:
> > Hi Greg, Hi JS,
> > Matteo and I have started to develop linux device drivers for our STMicroelectronics sensors about one year ago. Our main target is the Android platform (mobile phone or tablet pc), and for this reason the drivers are thought to be used on I2C bus. The drivers are enough stable, we have several customers that are using them, and also with the advice of these customers, we would like to make available them for all the linux community, merging them in the kernel upstream to be used in all linux supported platforms.
> > The drivers have had a initial review by Alan Cox, that gives us some very precious advices to improve the style and robustness of the drivers. 
> > We are newbies in patch generation and submission: we have followed the instructions in the Greg's video on you tube to create this first patch, so sorry if there is something that we missed. We thought to put the driver in staging directory, because before merging them in the main tree we would like to have a general revision, and also because in this first release we haven't managed the device interrupts yet. At the end the right position for these drivers could be drivers/input/misc.
> > How do we proceed now? Do we need to generate a new patch adding the TODO file? Please advice.
> 
> Hi, well, I don't think this should go into staging at all as I think
> it's clean enough to go upstream directly (but I repeat I'm no IIC
> expert). So please resend to IIC people:
> I2C SUBSYSTEM
> M:      "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
> M:      "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
> L:      linux-i2c@vger.kernel.org
> 
> but before that, move that out of staging to drivers/i2c/ (or anywhere
> where it make sense).
> 
> It's perfectly OK to add functionality later (IRQs).

I agree, this should be sent to Jean and the i2c developers first.
Please work to get your driver into the main tree, only use staging as a
last-resort if you have a lot of work left to do on the code.

thanks,

greg k-h
