Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab1CBUBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:01:15 -0500
Received: from smtp.getmail.no ([84.208.15.66]:38978 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab1CBUBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:01:14 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
References: <op.vrm3n5yy6426ze@millennium> <4D6CD10E.3050805@ladisch.de>
 <op.vrob5de16426ze@millennium> <4D6DF1B2.2010500@ladisch.de>
Subject: Re: Possible bug, with extreme low latency audio.
To: linux-kernel@vger.kernel.org, clemens@ladisch.de
Date: Wed, 02 Mar 2011 21:01:11 +0100
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.vrqe79rh6426ze@millennium>
In-reply-to: <4D6DF1B2.2010500@ladisch.de>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Mar 2011 08:28:50 +0100, Clemens Ladisch <clemens@ladisch.de>
wrote:

> Uwaysi Bin Kareem wrote:
>> The other is a firewire device (Konnekt24d using FFADO, running on the  
>> old
>> firewire stack).
>> The firewire device actually plays nicely without much buffer underruns
>> down to 0.363 ms latency (8x2 @ 44.1k).
>
> FireWire packets are sent every 125 µs; for audio, every packet contains
> either zero or eight samples, and the proportion of data and no-data
> packets is adjusted so that the overall rate is 44100 samples per
> second.  So 8x2 is the theoretical minimum.
>
>> However it seems to choke at 8x2 @ 96k.
>
> At sample rates above 48 kHz, there are 16 samples per packet (and above
> 96 kHz, 32).  It is not possible to use 8x2 at 96 kHz, and FFADO should
> not have allowed you to try it; please file a bug there:
> <http://subversion.ffado.org/report> (requires a login).
>
Ok, I am hitting the hardware limits. I'll inform FFADO crew about this.  
There are probably more bound to hit this limit, as lowlatency operation  
with Linux, is getting this good. A good error msg with the above  
information, would be good.

Best Regards,
Uwaysi.

