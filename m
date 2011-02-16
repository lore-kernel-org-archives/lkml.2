Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1BPQxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:53:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36086 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753296Ab1BPQxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:53:32 -0500
Date: Wed, 16 Feb 2011 08:53:49 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        "dilinger@queued.net" <dilinger@queued.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: platform data and mfd design question
Message-ID: <20110216165348.GB4390@opensource.wolfsonmicro.com>
References: <4D5AF554.2030208@codeaurora.org>
 <4D5B8F61.3090105@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5B8F61.3090105@stericsson.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 09:48:33AM +0100, Linus Walleij wrote:
> On 02/15/2011 10:51 PM, Abhijeet Dharmapurikar wrote:
> >Msm on the other hand declares the struct mfd_cell subdevice[] array in
> >the board file and passes this on to the core driver via platfom data.

> This way the platform data tells the core driver what kind of
> silicon it has "hey, PM8058, guess what, you have an RTC!"
> which looks backwards to me, especially given that it does
> not need any fancy platform data at all, just two IRQ numbers
> which the core driver can very well handle.

Indeed, and the RTC would still be useful even without IRQ support I
imagine (it should still be able to tell you the time).
