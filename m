Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1LSSUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 13:20:31 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15407 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab1LSSU2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 13:20:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 19 Dec 2011 10:20:27 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 19 Dec 2011 10:20:05 -0800
Subject: RE: [PATCH 2/2] pinctrl: Pass name instead of device to pin_config_*
Thread-Topic: [PATCH 2/2] pinctrl: Pass name instead of device to
 pin_config_*
Thread-Index: Acy91C/2yZVZLRGfQV+wnmONAaUnzAApkRzg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF176BE92A7E@HQMAIL01.nvidia.com>
References: <1323993437-15149-1-git-send-email-swarren@nvidia.com>
	<1323993437-15149-2-git-send-email-swarren@nvidia.com>
 <CACRpkdaKWcCReO27O6VjQNBCnSDu_tMLPLCkqR0aroUf7gLEVw@mail.gmail.com>
In-Reply-To: <CACRpkdaKWcCReO27O6VjQNBCnSDu_tMLPLCkqR0aroUf7gLEVw@mail.gmail.com>
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

Linus Walleij wrote at Sunday, December 18, 2011 3:27 PM:
> On Fri, Dec 16, 2011 at 12:57 AM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > Obtaining a "struct pinctrl_dev *" is difficult for code not directly
> > related to the pinctrl subsystem. However, the device name of the pinctrl
> > device is fairly well known. So, modify pin_config_*() to take the device
> > name instead of the "struct pinctrl_dev *".
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> Thanks Stephen, excellent, both applied.
> 
> I had to fix it up a bit to match the other
> refactoring patch I made so check the result in my tree or -next.

Yes, I think that looks fine, thanks.

Thanks for fixing up the documentation for me too.

BTW, do you know which commits you're planning on you're planning on
sending to mainline during the next merge window? If it includes these
two patches, I may be able to convert Tegra over to using the new pinctrl
driver in 3.3. And is your for-next branch stable (i.e. never rebased)
so that the arm-soc tree can use it as a dependency for my patches?

-- 
nvpublic

