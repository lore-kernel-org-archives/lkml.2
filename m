Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab1LELJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:09:39 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40110 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab1LELJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:09:36 -0500
MIME-Version: 1.0
In-Reply-To: <20111205105733.GE11150@opensource.wolfsonmicro.com>
References: <1321615040-13257-1-git-send-email-rnayak@ti.com>
	<1321615040-13257-2-git-send-email-rnayak@ti.com>
	<CAJuYYwRO+AS=WmQfNAe8L6Gi5Dm4VsCuVqk3X5Nb8uUYAdLnJQ@mail.gmail.com>
	<20111204155433.GA16287@opensource.wolfsonmicro.com>
	<CAJuYYwQ-9wCu-+q0S2YYeFYemq74ULdZ-EwPGLWKHA4+0VZcsA@mail.gmail.com>
	<20111205103447.GC11150@opensource.wolfsonmicro.com>
	<CAJuYYwSRW-=XufvHS1miO2xNANwQMZqPbt=VyPEonywnAsvVUQ@mail.gmail.com>
	<20111205105733.GE11150@opensource.wolfsonmicro.com>
Date: Mon, 5 Dec 2011 16:39:35 +0530
Message-ID: <CAJuYYwTu6iPBSy63Y65KtO1iR7PLKQkmFZn6uS4yv_o8ZWSftw@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] regulator: helper routine to extract regulator_init_data
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rajendra Nayak <rnayak@ti.com>, grant.likely@secretlab.ca,
        robherring2@gmail.com, linaro-dev@lists.linaro.org, patches@linaro.org,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 December 2011 16:27, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Dec 05, 2011 at 04:14:40PM +0530, Thomas Abraham wrote:
>> On 5 December 2011 16:04, Mark Brown
>
>> > With the regulator device tree bindings if the regulator is configured
>> > to run a single voltage the bindings will set apply_uV unconditionally
>> > so there's no need for a separate constraint.
>
>> Sorry if I have missed this, but I could not find 'apply_uV' being set
>> as you described in the v5 of the regulator-dt patchset.
>
> Yes, looks like Rajendra missed that - just fixed it.
>

Thanks Mark. Could you please push your change.

Regards,
Thomas.
