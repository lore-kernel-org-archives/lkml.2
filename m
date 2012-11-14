Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992440Ab2KNWuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:50:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61296 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933183Ab2KNWu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:50:29 -0500
MIME-Version: 1.0
In-Reply-To: <50A3F06F.20809@wwwdotorg.org>
References: <1352755511-28436-1-git-send-email-marek.belisko@open-nandra.com>
 <1352755511-28436-2-git-send-email-marek.belisko@open-nandra.com>
 <CAK5ve-L=SBFEfoY8oKYYb-dFCWf=-Eb-qMFdWdiBO3wfaR3tDA@mail.gmail.com> <50A3F06F.20809@wwwdotorg.org>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 14 Nov 2012 14:50:07 -0800
Message-ID: <CAK5ve-KbZJJHSrL8vuAwU2C1DQ4tTD8DwC2=4N830iALv-a9EA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] Add documentation for tca6507 devicetree bindings.
To: Stephen Warren <swarren@wwwdotorg.org>,
        Marek Belisko <marek.belisko@open-nandra.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@nvidia.com>, rpurdie@rpsys.net,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 11:26 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/13/2012 06:05 PM, Bryan Wu wrote:
>> It looks fine to me, but I need a DT maintainer's ack. Stephen, could
>> you help on this. I will merge this patch via my tree.
>
> I'm not actually a DT maintainer; I CC'd Grant and Rob.

Sure, thanks for this.

> Marek probably wants to repost the whole patch to them. Comments below.
>
>>> diff --git a/Documentation/devicetree/bindings/leds/tca6507.txt b/Documentation/devicetree/bindings/leds/tca6507.txt
> ...
>>> +LED sub-node properties:
> ...
>>> +  string defining the trigger assigned to the LED.  Current triggers are:
>>> +    "backlight" - LED will act as a back-light, controlled by the framebuffer
>>> +                 system
>>> +    "default-on" - LED will turn on
>>> +    "heartbeat" - LED "double" flashes at a load average based rate
>>> +    "ide-disk" - LED indicates disk activity
>>> +    "timer" - LED flashes at a fixed, configurable rate
>
> It would be useful to point at a single canonical document that
> describes the triggers, rather than duplicating the list into every binding.
>

Yeah, actually I saw several leds related DT binding txt are similar
and probably based on Documentation/devicetree/bindings/gpio/led.txt.
It's good to have a common one. Marek, are you going to do this? Thanks.

> Aside from that, I think this looks reasonable.
>
> Oh, looking at Documentation/devicetree/bindings/gpio/led.txt, should a
> default-state property be supported?

I'm not sure about this for ti,tca6507 and it really depends on the
driver implementation. But we can add this later.

-Bryan
