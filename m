Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab2DJIo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:44:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37876 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab2DJIoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:44:25 -0400
Message-ID: <4F83F2E3.6010703@suse.cz>
Date: Tue, 10 Apr 2012 10:44:19 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120404 Thunderbird/13.0a2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Chris Wilson <chris@chris-wilson.co.uk>, Jiri Slaby <jirislaby@gmail.com>,
        Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, daniel@ffwll.ch
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared [generic IRQ handling
 broken?]
References: <4F717CE3.4040206@suse.cz> <4F717D80.9040207@suse.cz> <4F758400.3080907@suse.cz> <1333104359_155028@CP5-2952> <4F75A303.3030409@suse.cz> <1333110296_156038@CP5-2952> <4F7F60BF.9070500@suse.cz> <alpine.LFD.2.02.1204062343050.2542@ionos>
In-Reply-To: <alpine.LFD.2.02.1204062343050.2542@ionos>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2012 12:40 AM, Thomas Gleixner wrote:
> On Fri, 6 Apr 2012, Jiri Slaby wrote:
>> It very looks like the generic IRQ handling code is broken. Like it
>> frees/corrupts irq_desc and ...
> 
> OMG, your problem analyzing skills are amazing.

Hehe, no I did *no* analysis. I stand here as a bug reporter.

> What the heck makes you assume that the irq core code is broken?  Core
> code, which works on a gazillion of machines and different device
> drivers and does not corrupt anything except that i915 thingy?

Note that this is a -next regression. And i915 graphics used. This
definitely doesn't run on a gazillion of machines.

> If you're still convinced that the irq core is messing with your
> device string,

Nope, thanks for the input.

-- 
js
suse labs


