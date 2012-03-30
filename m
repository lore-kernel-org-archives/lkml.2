Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011Ab2C3ML6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:11:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62813 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab2C3MLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:11:53 -0400
Message-ID: <4F75A303.3030409@suse.cz>
Date: Fri, 30 Mar 2012 14:11:47 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120320 Thunderbird/13.0a2
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: Jiri Slaby <jirislaby@gmail.com>, Keith Packard <keithp@keithp.com>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        daniel@ffwll.ch
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
References: <4F717CE3.4040206@suse.cz> <4F717D80.9040207@suse.cz> <4F758400.3080907@suse.cz> <1333104359_155028@CP5-2952>
In-Reply-To: <1333104359_155028@CP5-2952>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 12:45 PM, Chris Wilson wrote:
> On Fri, 30 Mar 2012 11:59:28 +0200, Jiri Slaby <jslaby@suse.cz> wrote:
>> I don't know what to dump more, because iir is obviously zero too. What
>> other sources of interrupts are on the (G33) chip?
> 
> IIR is the master interrupt, with chained secondary interrupt statuses.
> If IIR is 0, the interrupt wasn't raised by the GPU.

This does not make sense, the handler does something different. Even if
IIR is 0, it still takes a look at pipe stats.

And this is MSI, so there can be no other source of the interrupt.
(Except broken IRQ routing.) I may try to boot with MSIs off if you
think it's important.

thanks,
-- js suse labs


