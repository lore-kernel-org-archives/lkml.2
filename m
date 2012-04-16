Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab2DPS5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:57:01 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51361 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2DPS47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120416185153.GH3219@opensource.wolfsonmicro.com>
References: <1332582590-16382-3-git-send-email-thomas.abraham@linaro.org>
	<20120416185153.GH3219@opensource.wolfsonmicro.com>
Date: Tue, 17 Apr 2012 00:26:57 +0530
Message-ID: <CAJuYYwSK=T3Fi=mOwjuBciEbG9dD5x8PvqGO3mfF-4qdL50QrA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] regulator: add device tree support for max8997
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, k.lewandowsk@samsung.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        Rajendra Nayak <rnayak@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 April 2012 00:21, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Sat, Mar 24, 2012 at 03:19:50PM +0530, Thomas Abraham wrote:
>> Add device tree based discovery support for max8997.
>
> I tried to apply this but it's collided with some other changes in the
> driver which have arrived in the meantime and the rejects were too large
> to fix up.  I suspect it's mostly just the change in parameters for
> regulator_register().  Can you please regenerate against my current
> topic/drivers branch?

Hi Mark,

Sure, I will do redo this patch based on your current 'topic/drivers' branch.

Thanks,
Thomas.
