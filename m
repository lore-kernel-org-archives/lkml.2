Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab2B0SVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:21:52 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3546 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab2B0SVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:21:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 27 Feb 2012 10:21:30 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 27 Feb 2012 10:21:29 -0800
Subject: RE: [PATCH 17/20] pinctrl: Add usecount to pins for muxing
Thread-Topic: [PATCH 17/20] pinctrl: Add usecount to pins for muxing
Thread-Index: Acz1Hix2xcCU6DslSBC8tmIdguNxygAXjrpA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCFB6@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-18-git-send-email-swarren@nvidia.com>
 <20120227071150.GA26061@shlinux2.ap.freescale.net>
In-Reply-To: <20120227071150.GA26061@shlinux2.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dong Aisheng wrote at Monday, February 27, 2012 12:12 AM:
> On Sun, Feb 19, 2012 at 11:45:57PM -0700, Stephen Warren wrote:
> > Multiple mapping table entries could reference the same pin, and hence
> > "own" it. This would be unusual now that pinctrl_get() represents a single
> > state for a client device, but in the future when it represents all known
> > states for a device, this is quite likely. Implement reference counting
> > for pin ownership to handle this.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
...
> >  	/*
> > -	 * If there is no kind of request function for the pin we just assume
> > -	 * we got it by default and proceed.
> > -	 */
> > +	* If there is no kind of request function for the pin we just assume
> > +	* we got it by default and proceed.
> > +	*/
>
> I remember the correct format for multiple lines of comments is:
> /*
>  * ...
>  */
> 
> But i see the changes here are(i'm using mutt):
> /*
> * ...
> */
> Can you help explain?

It was a mistake; my editor corrupted it when I added or removed some
indentation levels. I noticed this and fixed it locally when doing
some rebasing.

> Else please also take my ACK:
> Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Thanks.

-- 
nvpublic

