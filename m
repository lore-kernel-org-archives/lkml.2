Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab2LLDFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 22:05:23 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:34738 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab2LLDFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 22:05:22 -0500
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2012 22:05:22 EST
MIME-Version: 1.0
In-Reply-To: <20121211125713.GH9097@opensource.wolfsonmicro.com>
References: <1355120784-31118-1-git-send-email-a.kesavan@samsung.com>
	<1355120784-31118-2-git-send-email-a.kesavan@samsung.com>
	<1355120784-31118-3-git-send-email-a.kesavan@samsung.com>
	<20121210064650.GJ10927@opensource.wolfsonmicro.com>
	<loom.20121210T091624-754@post.gmane.org>
	<CAM4voanevLVXW5_WFts2cjDi-5aAbj1_2=EN1amfp14KnKXNug@mail.gmail.com>
	<20121211125713.GH9097@opensource.wolfsonmicro.com>
Date: Wed, 12 Dec 2012 08:28:36 +0530
Message-ID: <CAM4voanvKFmPoMr4xJKwRMETa0uN4O5+v1Q3+cTWSEXfu22zUQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] regulator: max77686: Add support for various
 operating modes
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, Olof Johansson <olof@lixom.net>,
        Doug Anderson <dianders@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, sameo@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 6:27 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Dec 10, 2012 at 02:06:49PM +0530, Abhilash Kesavan wrote:
>> On Mon, Dec 10, 2012 at 1:49 PM, Abhilash Kesavan
>> <kesavan.abhilash@gmail.com> wrote:
>
>> > Mark Brown <broonie <at> opensource.wolfsonmicro.com> writes:
>
>> >> Binding documenation is mandatory for any new OF properties, please add
>> >> this.
>
>> > Patch 3/3 of this series adds documentation for the max77686-opmode property.
>
> There is no point in splitting changes like this up, it just makes
> review harder - in this case it caused me to not read your patch due
> to the missing documentation.  Put the whole change together unless
> things are getting too big to review.
OK.

Can you please have a look at Doug's proposal for handling the
operating mode generically in patch 3/3 of this series.
If you are OK with it then I'll start work on implementing it.

Thanks,
Abhilash
