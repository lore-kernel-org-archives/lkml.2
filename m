Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab1GVIBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 04:01:48 -0400
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:37379 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1GVIBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 04:01:47 -0400
Message-ID: <4E292F01.1040400@ladisch.de>
Date: Fri, 22 Jul 2011 10:04:17 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.39.2: alsa question: usb sound/card shows up as mixer1/audio1?
References: <alpine.DEB.2.02.1107141656480.10111@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1107141656480.10111@p34.internal.lan>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> I bought two of these but they are actually different devices, on one host 
> it works ok, on the other, I get this:
> ...
> $ cat /proc/asound/cards
>   1 [Device         ]: USB-Audio - C-Media USB Audio Device
>                        C-Media USB Audio Device at usb-0000:00:1d.7-2.4, full speed
> 
> On the working host:
> $ cat /proc/asound/cards
>   0 [Device         ]: USB-Audio - USB PnP Sound Device
>                        C-Media Electronics Inc. USB PnP Sound Device at usb-0000:00:1d.7-2.4, full spe
> 
> Any clue why one is mapped to [1] and the other [0], where the one that is
> [0] works properly and the [1] does not?

Some distributions configure USB devices to not load at index 0 to
prevent conflicts with the primary PCI sound card.  Have a look into
/etc/modprobe.d/.


Regards,
Clemens
