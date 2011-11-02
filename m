Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111Ab1KBTgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 15:36:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab1KBTgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 15:36:24 -0400
Message-ID: <4EB19BB4.6030505@redhat.com>
Date: Wed, 02 Nov 2011 15:36:20 -0400
From: Adam Jackson <ajax@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 3/7] drm/i915: Treat PCH eDP like DP in most
 places
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-4-git-send-email-keithp@keithp.com> <20111102092019.3a635632@jbarnes-desktop> <4EB17A50.6050804@redhat.com> <yun8vnywhvh.fsf@aiko.keithp.com>
In-Reply-To: <yun8vnywhvh.fsf@aiko.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/11 1:31 PM, Keith Packard wrote:
> On Wed, 02 Nov 2011 13:13:52 -0400, Adam Jackson<ajax@redhat.com>  wrote:
>
>> Given the choice of trusting DPCD or the VBT, I'd definitely prefer
>> DPCD.
>
> Except that the DPCD is coded into the monitor while the VBT is done by
> the platform. And, it's the platform which may neglect to connect some
> of the wires.

My reasoning about this has been:

The maximum link configuration in DPCD is going to fit - and minimally 
fit - the maximum supported configuration (depth/rate/size/etc), because 
otherwise the hardware would have been more expensive to produce.

The VBT is going to be crap.

But as always, "do what the Windows driver does" seems like a good 
strategy.  Do we know?

> Any bets on how long until we find a machine that has right value in the
> VBT and the wrong one in DPCD? Or a machine with wrong values in both places?

I will happily pay $20 to the first person to find a monitor with broken 
link/lane in DPCD, on the understanding that they take it (the $20) to 
the nearest hardware store, buy a hammer, and smash the monitor. 
Preferably with the video uploaded to youtube.

- ajax
