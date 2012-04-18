Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab2DRUgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:36:38 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47015 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab2DRUgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:36:06 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.84.216]
In-Reply-To: <87y5ptkl0u.fsf@ti.com>
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
	<1332173578-27422-2-git-send-email-j-pihet@ti.com>
	<87y5ptkl0u.fsf@ti.com>
Date: Wed, 18 Apr 2012 22:36:05 +0200
Message-ID: <CAORVsuWBHVhHnqBeKQ8hb2p+UsRP84O-Hq=bXYQv2wBJyfELGA@mail.gmail.com>
Subject: Re: [PATCH 1/9] ARM: OMAP3+: voltage: export functions to plat/voltage.h
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Kevin Hilman <khilman@ti.com>, KEERTHY J <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Jean Pihet <j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

Adding Keerthy J

On Wed, Apr 18, 2012 at 7:27 PM, Kevin Hilman <khilman@ti.com> wrote:
> Hi Jean,
>
> jean.pihet@newoldbits.com writes:
>
>> From: Jean Pihet <j-pihet@ti.com>
>>
>> Move some functions from mach-omap2/ dir to the plat/ dir.
>> The SmartReflex class driver is a user of the basic voltage domains
>> functions (enable, disable, reset).
>>
>> Signed-off-by: Jean Pihet <j-pihet@ti.com>
>> Cc: Kevin Hilman <khilman@ti.com>
>
> Rather than expose the VP functions directly, how about adding a new API
> at the voltdm layer to start/stop AVS.  Maybe something like:
>
>  voltdm_avs_start(struct voltagedomain *voltdm)
>  voltdm_avs_stop(struct voltagedomain *voltdm)
>
> These will internally just call VP enable/disable for now, but we may
> have more to add to these in the future to support other SR classes.
Agree.
That would be a first step in the definition of the API between SR and
VP. Implementing other SR classes might require more than that, this
is still under investigation for now.

>
> Kevin
>

Thanks for reviewing,
Jean
