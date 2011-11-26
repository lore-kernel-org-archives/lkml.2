Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1KZQjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 11:39:54 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56662 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab1KZQjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 11:39:53 -0500
MIME-Version: 1.0
In-Reply-To: <86pqge96z1.fsf@sumi.keithp.com>
References: <CAGPN=9THOv-M4Td4haE94uDcsAjW3eGMG7ioLeu+p8xUOBPd7w@mail.gmail.com>
	<861usye0og.fsf@sumi.keithp.com>
	<CAGPN=9ROa_Pf242jxPy-6XfmFNW3+sCMj6M+pFbw+wgCX3tu1Q@mail.gmail.com>
	<86sjlccchg.fsf@sumi.keithp.com>
	<CAGPN=9SLsESVPdwhBwJN9G+nkENcFDqhrcva8GC-VTnx_E=apg@mail.gmail.com>
	<86pqge96z1.fsf@sumi.keithp.com>
Date: Sat, 26 Nov 2011 17:39:52 +0100
Message-ID: <CAGPN=9RZgCJy9hF4RqY1BLmC7cA7QWavWfRM26U3czWZ6RBNMQ@mail.gmail.com>
Subject: Re: i915: 3.2 rc1/2 KMS regression
From: Patrik Kullman <patrik.kullman@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/26 Keith Packard <keithp@keithp.com>:
> On Sat, 26 Nov 2011 10:55:31 +0100, Patrik Kullman <patrik.kullman@gmail.com> wrote:
>> Well, booting the broken kernel freezes the machine unless I specify
>> i915.modeset=0.
>
> Freezes it so you can't even access it over the network? That would be
> quite surprising.

As far as I can tell it does, Caps Lock doesn't respond, for example.
Also, the machine doesn't have an Ethernet port, the USB->Ethernet
adapter isn't supported in mainline kernel and I don't have a
convenient way to auto-logon to wireless.

Hope we can do without this log?

>> Do you want a log in that configuration?
>
> No, those wouldn't be useful (modeset=0 doesn't do a lot of
> modesetting :-)
>
>> I will provide the logs next week when I have my charger back...
>
> Thanks.
>
> --
> keith.packard@intel.com
>
