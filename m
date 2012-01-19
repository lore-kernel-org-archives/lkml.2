Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab2ASRwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:52:16 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10076 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab2ASRwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:52:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 19 Jan 2012 09:52:14 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chanho Park <chanho61.park@samsung.com>
Date: Thu, 19 Jan 2012 09:52:13 -0800
Subject: RE: [PATCH] pinctrl: Fix pinconf_pins_show iteration
Thread-Topic: [PATCH] pinctrl: Fix pinconf_pins_show iteration
Thread-Index: AczPeJitzp1+H9lpRmC7+qJ2QNyIDQHWl3hQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB0F3@HQMAIL01.nvidia.com>
References: <1325882311-7504-1-git-send-email-swarren@nvidia.com>
 <CACRpkdY+qpm1na_fdSEiSeBPQNFYf4JTapVE5o6m07OQiaoPCw@mail.gmail.com>
In-Reply-To: <CACRpkdY+qpm1na_fdSEiSeBPQNFYf4JTapVE5o6m07OQiaoPCw@mail.gmail.com>
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

Linus Walleij wrote at Tuesday, January 10, 2012 2:17 AM:
> On Fri, Jan 6, 2012 at 9:38 PM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > Commit 706e852 "pinctrl: correct a offset while enumerating pins"
> > modified the variable used by pinconf_pin_show()'s for loop, but didn't
> > update the for loop test expression.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> OK applied to my fixes branch, will send this along with any other
> fixes once Torvalds has pulled the pinctrl tree for this merge window.

Linus,

This still hasn't shown up in next-20120119. Is that expected?

Thanks.

-- 
nvpublic

