Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934629Ab1JaWhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:37:39 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:48778 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934573Ab1JaWhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:37:37 -0400
Date: Mon, 31 Oct 2011 23:37:29 +0100
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Nico Schottelius <nico-linux-20111017@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Keyboard and mouse issues on MacBook Air (4,2)
Message-ID: <20111031223729.GB26627@ethz.ch>
Mail-Followup-To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
References: <20111017175906.GA3461@schottelius.org>
 <alpine.LRH.2.00.1110172015050.3869@twin.jikos.cz>
 <20111017214050.GA1408@schottelius.org>
 <20111019150122.GA6157@schottelius.org>
 <alpine.LNX.2.00.1110191702470.3541@pobox.suse.cz>
 <20111019210742.GA2432@schottelius.org>
 <20111022020205.GA26724@schottelius.org>
 <20111022102427.GB26724@schottelius.org>
 <alpine.LNX.2.00.1110281745290.3541@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1110281745290.3541@pobox.suse.cz>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.0-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina [Fri, Oct 28, 2011 at 05:46:29PM +0200]:
> On Sat, 22 Oct 2011, Nico Schottelius wrote:
> 
> > The missing bit to correct my previous patch: To which device IDs do the 
> > devices named above match to? I.e. is USB_DEVICE_ID_APPLE_WELLSPRING6_* 
> > the MacBook Air 4,2?
> 
> You need to check the USB IDs (lsusb will tell you) to see which quirk / 
> translation table is getting used.

Alright, will prepare a better patch the next weeks (currently no access
to a 4,2 air). So far I've found three different keyboard layouts on the
Air:

2,1 has all keys from F1-F12 mapped, same as 4,2
3,1 has the quirk with missing F5 mapping

I've the usb ids for 2,1 and 4,2 right now and will try to get it
from 3,1 as well.

If anyone with a MacBook Air 3,2 or 4,1 (or any other version not listed
above) is reading this, can you send me an email with the output of
lsusb (or the system profiler from macosx) and which multimedia keys are
mapped to which F1-F12 keys?

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
