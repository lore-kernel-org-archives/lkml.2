Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab2FKETs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 00:19:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40641 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2FKETq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 00:19:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120611033701.GC4218@opensource.wolfsonmicro.com>
References: <1339148851-19289-1-git-send-email-yadi.brar@samsung.com>
	<20120611033701.GC4218@opensource.wolfsonmicro.com>
Date: Mon, 11 Jun 2012 09:49:39 +0530
Message-ID: <CAKew6eW4QgXDEG9XM9-sjw1_D7GrMeZYo81AEQyfkCE5qsLHXw@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: core: Add regulator_set_voltage_time_sel
 to calculate ramp delay.
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 9:07 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Jun 08, 2012 at 03:17:30PM +0530, Yadwinder Singh Brar wrote:
>> This patch adds regulator_set_voltage_time_sel(), to move the commonly used
>> code by drivers to provide the .set_voltage_time_sel callback.It will also
>> allow us to configure different ramp delay for different regulators easily.
>
> Applied, thanks.

Actaully I had posted V2 for this patch with a little correction
(i.e. converting ramp_delay to uV/us before using for
DIV_ROUND_UP)
+                       rdev->desc->ramp_delay * 1000);

I missed to write it in patch summary.

Thanks,
Yadwinder.
