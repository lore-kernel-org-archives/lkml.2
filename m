Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab1JSO6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:58:06 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:60415 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab1JSO6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:58:05 -0400
Date: Wed, 19 Oct 2011 16:58:00 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nico Schottelius <nico-linux-20111017@schottelius.org>,
        Arend van Spriel <arend@broadcom.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
Message-ID: <20111019145800.GC1414@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
References: <20111019123602.GA11883@schottelius.org>
 <1319028563.8416.1.camel@edumazet-laptop>
 <20111019130749.GD11883@schottelius.org>
 <20111019142837.GA1414@schottelius.org>
 <1319035584.8416.34.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1319035584.8416.34.camel@edumazet-laptop>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.1.0-rc6-gbee709a x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet [Wed, Oct 19, 2011 at 04:46:24PM +0200]:
> Le mercredi 19 octobre 2011 à 16:28 +0200, Nico Schottelius a écrit :
> > Triggered it! 
> > 
> > And also got the traceback!
> > 
> > Dmesg + log attached, let me know when I can pull the fix from
> > somewhere.
> > 
> 
> Sorry, I cant see same messages in your dmesg, no mention of stuck
> processes (blocked for more than 120 seconds.)
> 
> By the way, please update to latest 3.1.rc10
 
I can rebuild Linus' tree if you want, but only use it temporarily due
to the other errors mentioned in the previous message.

If you've a tree somewhere that merges on top of Keith+Jiri,
I'd try to merge that one as well, to make the mba more usable.

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
