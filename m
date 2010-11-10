Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0KJLwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 06:52:12 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:46933 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754351Ab0KJLwK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 06:52:10 -0500
From: Carmine IASCONE <carmine.iascone@st.com>
To: Greg KH <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>
Cc: Matteo DAMENO <matteo.dameno@st.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mems applications <mems.applications@st.com>,
        Alan Cox <alan.cox@intel.com>
Date: Wed, 10 Nov 2010 12:51:21 +0100
Subject: RE: [PATCH] staging: lis331dlh: add lis331dlh driver
Thread-Topic: [PATCH] staging: lis331dlh: add lis331dlh driver
Thread-Index: AcuANj2P1zNdm1tUSriqewqEIELf1QAkPLtA
Message-ID: <3B4B64FC2A10C148B521CFCC54F4F7E49FA33DB115@SAFEX1MAIL3.st.com>
References: <> <1289323527-5501-1-git-send-email-carmine.iascone@st.com>
 <20101109173540.GA20370@suse.de>
In-Reply-To: <20101109173540.GA20370@suse.de>
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

Hi Greg, Hi JS,
Matteo and I have started to develop linux device drivers for our STMicroelectronics sensors about one year ago. Our main target is the Android platform (mobile phone or tablet pc), and for this reason the drivers are thought to be used on I2C bus. The drivers are enough stable, we have several customers that are using them, and also with the advice of these customers, we would like to make available them for all the linux community, merging them in the kernel upstream to be used in all linux supported platforms.
The drivers have had a initial review by Alan Cox, that gives us some very precious advices to improve the style and robustness of the drivers. 
We are newbies in patch generation and submission: we have followed the instructions in the Greg's video on you tube to create this first patch, so sorry if there is something that we missed. We thought to put the driver in staging directory, because before merging them in the main tree we would like to have a general revision, and also because in this first release we haven't managed the device interrupts yet. At the end the right position for these drivers could be drivers/input/misc.
How do we proceed now? Do we need to generate a new patch adding the TODO file? Please advice.

Our email references are:

Carmine Iascone <carmine.iascone@st.com>
Matteo Dameno <matteo.dameno@st.com>

Best regards,
Carmine


-----Original Message-----
From: Greg KH [mailto:gregkh@suse.de] 
Sent: Tuesday, November 09, 2010 6:36 PM
To: mems applications
Cc: Carmine IASCONE; Matteo DAMENO; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lis331dlh: add lis331dlh driver

On Tue, Nov 09, 2010 at 06:25:27PM +0100, mems applications wrote:
> Add STMicroelectronics LIS331DLH digital accelerometer device driver
> 
> From: Carmine Iascone <carmine.iascone@st.com>
> ---
>  drivers/staging/Kconfig               |    2 +
>  drivers/staging/Makefile              |    1 +
>  drivers/staging/lis331dlh/Kconfig     |    7 +
>  drivers/staging/lis331dlh/Makefile    |    1 +
>  drivers/staging/lis331dlh/lis331dlh.c |  836 +++++++++++++++++++++++++++++++++
>  drivers/staging/lis331dlh/lis331dlh.h |   83 ++++
>  6 files changed, 930 insertions(+), 0 deletions(-)

Why is this a staging driver?  What is keeping it from being merged to
the main portion of the kernel tree?

Can you please provide a TODO file that lists the things left to do on
it, and provide some email addresses to contact you for it?  Look at the
other TODO files in drivers/staging/*/TODO for examples.

thanks,

greg k-h
