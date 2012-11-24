Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab2KXSQx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 13:16:53 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:36676 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2KXSQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 13:16:52 -0500
MIME-Version: 1.0
In-Reply-To: <20121124175954.GI4719@opensource.wolfsonmicro.com>
References: <1353657795-1725-1-git-send-email-thomas.abraham@linaro.org>
	<1353657795-1725-4-git-send-email-thomas.abraham@linaro.org>
	<20121124175954.GI4719@opensource.wolfsonmicro.com>
Date: Sat, 24 Nov 2012 23:46:51 +0530
Message-ID: <CAJuYYwThsFutYnYg2scmfqUAGxBM2pWmRmoTww+OyZgUuA-7vg@mail.gmail.com>
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

On 24 November 2012 23:29, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Nov 23, 2012 at 01:33:15PM +0530, Thomas Abraham wrote:
>
>> This v6 patch is rebased to the latest max8997 driver code and there are no
>> functional changes from v5.
>
> That doesn't seem to be in mainline yet so the patch won't apply.

Hi Mark,

The max8997 driver is mainlined. I actually meant to say that, this v6
version of dt support patch for max8997, is similar in functionality
to the v5 version of this patch. I did prepare this patch based on
your latest for-next branch.

Thanks,
Thomas.
