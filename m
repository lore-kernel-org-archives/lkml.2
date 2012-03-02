Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab2CBRlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:41:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15710 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877Ab2CBRlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:41:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 02 Mar 2012 09:41:07 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 2 Mar 2012 09:41:04 -0800
Subject: RE: [PATCH] pinctrl: resurrect verbose pinmux-pins
Thread-Topic: [PATCH] pinctrl: resurrect verbose pinmux-pins
Thread-Index: Acz4lixCNm7g+kafTBifQmUDymm0IwAAk6OgAAC7AsA=
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BE861991@HQMAIL01.nvidia.com>
References: <1330705873-10798-1-git-send-email-linus.walleij@stericsson.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17BE861978@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BE861978@HQMAIL01.nvidia.com>
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

Stephen Warren wrote at Friday, March 02, 2012 10:22 AM:
> Linus Walleij wrote at riday, March 02, 2012 9:31 AM:
> > From: Linus Walleij <linus.walleij@linaro.org>
> >
> > This reintroduces the verbosity in the pinmux-pins file, now this
> > file will list all pins, their names, owning device (and if it's
> > a hog) and also in applicable cases the function and group making
> > use of that pin right now.
> >
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> It'd be nice if we could defer this fix until after all the API rework,
> because it'll cause all kinds of conflicts otherwise.

Oh, I see this patch is in your for-next branch already before I had a chance
to comment on it. I guess I'll have write a patch to convert the removed struct
type to char*s and rebase on top of it:-(

--
nvpublic

