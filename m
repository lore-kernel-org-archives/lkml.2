Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2KZNqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:46:07 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44618 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab2KZNqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:46:05 -0500
MIME-Version: 1.0
In-Reply-To: <20121126095141.GC9411@opensource.wolfsonmicro.com>
References: <1353657795-1725-1-git-send-email-thomas.abraham@linaro.org>
	<1353657795-1725-4-git-send-email-thomas.abraham@linaro.org>
	<20121124175954.GI4719@opensource.wolfsonmicro.com>
	<CAJuYYwThsFutYnYg2scmfqUAGxBM2pWmRmoTww+OyZgUuA-7vg@mail.gmail.com>
	<20121126095141.GC9411@opensource.wolfsonmicro.com>
Date: Mon, 26 Nov 2012 19:16:04 +0530
Message-ID: <CAJuYYwTt+1-zU3092GmrK2GHR=5QDGT-diVcm_0pe3=oqhuQdA@mail.gmail.com>
Subject: Re: [PATCH 3/3] regulator: add device tree support for max8997
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        myungjoo.ham@samsung.com, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, t.figa@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Rajendra Nayak <rnayak@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 November 2012 15:21, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Sat, Nov 24, 2012 at 11:46:51PM +0530, Thomas Abraham wrote:
>
>> The max8997 driver is mainlined. I actually meant to say that, this v6
>> version of dt support patch for max8997, is similar in functionality
>> to the v5 version of this patch. I did prepare this patch based on
>> your latest for-next branch.
>
> I find it hard to believe that this was generated against for-next, this
> was where I tried to apply it...

I tried again to apply this patch on 'for-next' branch of your
regulator tree (git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git)

on top of commit 6aa588f43d4a (Merge remote-tracking branches
'regulator/fix/wm831x', 'regulator/topic/as3711',
'regulator/topic/da9055', 'regulator/topic/hotplug',
'regulator/topic/lp8788'.....)

and this patch applied cleanly. Could you please let me know if there
is anything I need to be doing differently for this.

Thanks,
Thomas.
