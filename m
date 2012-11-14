Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423382Ab2KNT0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:26:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41994 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423233Ab2KNT0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:26:43 -0500
Message-ID: <50A3F06F.20809@wwwdotorg.org>
Date: Wed, 14 Nov 2012 12:26:39 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Bryan Wu <cooloney@gmail.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
CC: Marek Belisko <marek.belisko@open-nandra.com>,
        Stephen Warren <swarren@nvidia.com>, rpurdie@rpsys.net,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v3 2/2] Add documentation for tca6507 devicetree bindings.
References: <1352755511-28436-1-git-send-email-marek.belisko@open-nandra.com> <1352755511-28436-2-git-send-email-marek.belisko@open-nandra.com> <CAK5ve-L=SBFEfoY8oKYYb-dFCWf=-Eb-qMFdWdiBO3wfaR3tDA@mail.gmail.com>
In-Reply-To: <CAK5ve-L=SBFEfoY8oKYYb-dFCWf=-Eb-qMFdWdiBO3wfaR3tDA@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 06:05 PM, Bryan Wu wrote:
> It looks fine to me, but I need a DT maintainer's ack. Stephen, could
> you help on this. I will merge this patch via my tree.

I'm not actually a DT maintainer; I CC'd Grant and Rob. Marek probably
wants to repost the whole patch to them. Comments below.

>> diff --git a/Documentation/devicetree/bindings/leds/tca6507.txt b/Documentation/devicetree/bindings/leds/tca6507.txt
...
>> +LED sub-node properties:
...
>> +  string defining the trigger assigned to the LED.  Current triggers are:
>> +    "backlight" - LED will act as a back-light, controlled by the framebuffer
>> +                 system
>> +    "default-on" - LED will turn on
>> +    "heartbeat" - LED "double" flashes at a load average based rate
>> +    "ide-disk" - LED indicates disk activity
>> +    "timer" - LED flashes at a fixed, configurable rate

It would be useful to point at a single canonical document that
describes the triggers, rather than duplicating the list into every binding.

Aside from that, I think this looks reasonable.

Oh, looking at Documentation/devicetree/bindings/gpio/led.txt, should a
default-state property be supported?
