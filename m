Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab1IYOXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 10:23:46 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:50163 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752825Ab1IYOXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 10:23:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAFALQ4f05Ld+Jv/2dsb2JhbABCmT+OWnmBUwEBBTgeBhwBEAsLDQkWDwkDAgECAQ8CFh4GAQwBBQICsCiGRjuIc4cLBIlziV+KF4J1hEM
X-IronPort-AV: E=Sophos;i="4.68,439,1312171200"; 
   d="scan'208";a="138417976"
Message-ID: <4E7F3969.2050308@gmail.com>
Date: Sun, 25 Sep 2011 10:23:37 -0400
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110902 Firefox/6.0.2 SeaMonkey/2.3.3
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Chris Wilson <chris@chris-wilson.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regression: i915 blank issue on kernel 3.1.0-rc3
References: <4E7A6CED.5000501@gmail.com> <yun4o05xkgl.fsf@aiko.keithp.com>
In-Reply-To: <yun4o05xkgl.fsf@aiko.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Packard wrote:
> On Wed, 21 Sep 2011 19:02:05 -0400, Woody Suwalski<terraluna977@gmail.com>  wrote:
>
>> Chris, I do not know if it is i915 driver or X'drm or what..
>> Problem exists on 3.1.0, no problem on 3.0.3
> Any way you could narrow it down a bit more? A bisect should sort it out
> pretty quickly, given that you've got working code in 3.0 and
> not-working code in 3.1-rc. You can start by manually bisecting across the
> 3.1 release candidates, and then narrow it down from there by bisecting
> only across the drivers/gpu/drm/i915 directory.
>
I see that now more people are reporting a blanker problem. I guess 
kernel.org downtime is really impacting testing...

Anyway, for Eeepc reverting the

aaa6fd2a004147bf32fce05720938236de3361d9

seems to be fixing the issue. Which is not of course the way we want to go ;-(

Woody


