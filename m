Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0DZRhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 13:37:14 -0400
Received: from 007.netroom.de ([194.0.247.207]:8745 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab0DZRhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 13:37:11 -0400
Message-ID: <4BD5CF3C.9020406@draisberghof.de>
Date: Mon, 26 Apr 2010 19:37:00 +0200
From: Josua Dietze <digidietze@draisberghof.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
CC: Daniel Mack <daniel@caiaq.de>, Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: USB gadget with drivers "on board"
References: <op.vbrfqdznfxrvh1@pikus> <20100426141605.GO30801@buzzloop.caiaq.de> <op.vbrxsrw07p4s8u@pikus> <20100426145700.GP30801@buzzloop.caiaq.de> <op.vbr0prfb7p4s8u@pikus>
In-Reply-To: <op.vbr0prfb7p4s8u@pikus>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michał Nazarewicz schrieb:

> On Mon, 26 Apr 2010 16:16:05 +0200, Daniel Mack <daniel@caiaq.de> wrote:
>> Are you sure they don't do exactly that by running two interfaces in
>> the same configuration?
> 
> Yes, I'm sure.  I've investigated an USB GSM modem which, when plugged
> for the first time reports as mass storage (single configuration, single
> interface) and when drivers are installed as a full blown composite
> gadget.  I still haven't figured out how it does that.


These are the notorious mode switching devices. In Windows, they 
obviously install a special storage driver doing one specific action 
on each following plugging.
This action - some storage or control command - will "flip" the 
device, making it "disconnect" and returning as a completely different 
composite device.

Storage commands used for this procedure range from "SCSI rezero" over 
"passthrough" to "SCSI eject", or involve vendor specific stuff.


Josua Dietze

