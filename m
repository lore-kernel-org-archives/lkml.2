Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab2IQNmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:42:10 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59885 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2IQNmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:42:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120917104049.GC5401@opensource.wolfsonmicro.com>
References: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
	<1347855552-26213-4-git-send-email-haojian.zhuang@gmail.com>
	<20120917101914.GA5401@opensource.wolfsonmicro.com>
	<CAN1soZzTr-Zm0J41KXjnPei_9DtLF86fQbMpWyZzG9x=CWetiA@mail.gmail.com>
	<20120917104049.GC5401@opensource.wolfsonmicro.com>
Date: Mon, 17 Sep 2012 21:42:06 +0800
Message-ID: <CAN1soZyc0DKQTt6DrQn_REO+_8y8ebiAVN3avDHLTumkSSmAuw@mail.gmail.com>
Subject: Re: [PATCH 3/9] regulator: 88pm860x: add pre-regulator support for
 88pm860x regulator
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, lrg@ti.com, rpurdie@rpsys.net,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        "Jett.Zhou" <jtzhou@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 6:40 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Sep 17, 2012 at 06:28:18PM +0800, Haojian Zhuang wrote:
>
>> Could this patch be merged into MFD tree? Since the fourth patch in this
>> patch series is depend on this one.
>
> Why is there a dependency?
> --
This patch is picked from Jett's patch on power device of 88pm860x.
His patch addes the support
of PREG regulator in 88pm8607 regulator driver. Although this patch
was submitted for a long time,
it wasn't merged yet.

And I have a patch series on updating 88pm860x driver with
IORESOURCE_REG. One patch in that
series is used to split regulator subdevs into an array of regulator
subdevs. It results in 88pm860x
regulator driver updated and merged into MFD for-next branch.

Since both Jett's patch and my patch updates code in probe() function
of 88pm860x regulator driver,
some code between these two patches conflicts. So I make the fourth
patch in current series to resolve
this conflict on MFD for-next branch.

If you agree on merging this patch series into MFD tree without your
Ack, it would be simple way. Or I
could rebase it and split them into two different patch series for MFD
and regulator tree. Which way do
you like?

Best Regards
Haojian
