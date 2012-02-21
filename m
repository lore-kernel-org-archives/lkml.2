Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2BURun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:50:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4491 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab2BURum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:50:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 21 Feb 2012 09:50:22 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Feb 2012 09:50:18 -0800
Subject: RE: [PATCH 13/20] pinctrl: Error if mapping table's control dev
 can't be found
Thread-Topic: [PATCH 13/20] pinctrl: Error if mapping table's control dev
 can't be found
Thread-Index: AczwoPVvC/fLFarcQgikVdb0vcX8dwAIDBQA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC32F@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-14-git-send-email-swarren@nvidia.com>
 <CACRpkdaEVSxpR3z93_bfG28_vj4i5z9Zpne4XUhvTz7fvkXypg@mail.gmail.com>
In-Reply-To: <CACRpkdaEVSxpR3z93_bfG28_vj4i5z9Zpne4XUhvTz7fvkXypg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Tuesday, February 21, 2012 6:59 AM:
> On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > This is a serious error, and the pin control system will not function
> > correctly if it ends up not programing the mapping table entries into
> > the HW. Instead of just ignoring this, error out.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> Thanks applied, this came to bite me today so I see the value
> of being strict here.
> 
> > +                       /* Eventually, this should trigger deferred probe */
> > +                       return -ENODEV;
> 
> I changed this to ERR_PTR(-ENODEV) in my codebase as
> it returns a pointer.

Thanks. I thought I'd fixed that up after compiling each patch individually,
but I guess I missed one:-(

-- 
nvpublic

