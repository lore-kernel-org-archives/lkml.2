Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1LaLsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 06:48:25 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:39837 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1LaLsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 06:48:23 -0500
Date: Sat, 31 Dec 2011 12:48:26 +0100
From: Nico Schottelius <nico-linux-20111201@schottelius.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Nico Schottelius <nico-linux-20111201@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        b43-dev@lists.infradead.org, Greg KH <gregkh@suse.de>
Subject: Re: BCM43224 hanging [3.2.0-rc5]
Message-ID: <20111231114826.GD2305@ethz.ch>
Mail-Followup-To: Nico Schottelius <nico-linux-20111201@schottelius.org>,
	Arend van Spriel <arend@broadcom.com>,
	LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
	b43-dev@lists.infradead.org, Greg KH <gregkh@suse.de>
References: <20111201224851.GB20536@ethz.ch>
 <4ED8B610.2010703@broadcom.com>
 <20111202150128.GC3096@schottelius.org>
 <20111207190821.GA1775@schottelius.org>
 <20111212181619.GD1975@schottelius.org>
 <20111214112148.GE3191@ethz.ch>
 <20111222102408.GA2643@schottelius.org>
 <4EF32E4B.7050307@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF32E4B.7050307@broadcom.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.2.0-rc7-00003-g4962516 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Arend,

Arend van Spriel [Thu, Dec 22, 2011 at 02:19:07PM +0100]:
> On 12/22/2011 11:24 AM, Nico Schottelius wrote:
> > Update:
> > 
> > - dmesg with hanging logs
> > - The hang problem seems to happen ONLY with a specific access point: c8:6c:87:a9:df:a9
> >   -> this is a zyxel P-2802HWL-I1, running at channel 13, with WPA2-PSK.
> >   -> If you need more information, just let me know
> > - Using wlan with the Samsung S2 as access point seems to work fine
> 
> Is the Samsung AP also on channel 13? If not, could you try it?

No it's not and I cannot change it. But I changed the other AP
from 13 to channel 3 and now the hang issue is gone. So this is
definitely related to the specific frequence.

Hope this is enough information to get it fixed evetually :-)

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
