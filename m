Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab0E0WAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:00:49 -0400
Received: from mail.svr02.mucip.net ([83.170.6.69]:55588 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab0E0WAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:00:47 -0400
X-Greylist: delayed 743 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2010 18:00:46 EDT
X-Submitted: to mailout.mucip.net (Postfix) with ESMTPSA id 38312496A
Message-ID: <4BFEE8A2.30706@birkenwald.de>
Date: Thu, 27 May 2010 23:48:18 +0200
From: Bernhard Schmidt <berni@birkenwald.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: Clock jumps
References: <loom.20100524T171038-56@post.gmane.org>	<20100525062100.GP22163@redhat.com>	<4BFD5616.6070302@cora.nwra.com>	<4D7E210A-4694-4B6E-B721-6024CE96ABC0@suse.de>	<htmdsk$9kn$1@dough.gmane.org> <AANLkTindrSuRdOI30l4P5XMuUVv3j7Zso9fMi1xREb3A@mail.gmail.com>
In-Reply-To: <AANLkTindrSuRdOI30l4P5XMuUVv3j7Zso9fMi1xREb3A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.05.2010 21:08, john stultz wrote:

Hi John,

> I'd be very interested in hearing more about the host side issue. So
> this happened with the same kernel that you were using before, with no
> trouble?

Correct.

> Could you also send dmesg output from this boot? And if you can find
> any older dmesg logs to compare with, send those too?

See http://users.birkenwald.de/~berni/temp/dmesg-lenny and 
http://users.birkenwald.de/~berni/temp/dmesg-squeeze . Although running 
on the same kernel binary the initrd changed greatly when upgrading, so 
ordering/timing between those two is off.

Note that the dmesg output is captured right after boot. I think I 
remember seeing a "TSC unstable" message pretty soon after boot, but I 
might be mixing it up with my other AMD-based KVM server. I don't hold 
normal (non-boot) logs that long, so I can't tell for sure.

If you need any more info feel free to contact me.

Bernhard
