Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab1JRNeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:34:08 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:43008 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab1JRNeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:34:07 -0400
Date: Tue, 18 Oct 2011 15:34:08 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Nico Schottelius <nico-linux-20111017@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
Message-ID: <20111018133408.GA16341@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	Arend van Spriel <arend@broadcom.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20111018111422.GA1979@schottelius.org>
 <4E9D7BCD.1050104@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9D7BCD.1050104@broadcom.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.1.0-rc6-gbee709a x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Arend,

Arend van Spriel [Tue, Oct 18, 2011 at 03:14:53PM +0200]:
> On 10/18/2011 01:14 PM, Nico Schottelius wrote:
> > Dear LKML,
> 
> In this case linux-wireless list may be more appropriate, adding it.
> 
> > The hardware is again the (in)famous MacBook Air 4,2, so I imagine this may be
> > related to brcmsmac.
> > 
> > Attached are config, dmesg, lsmod.
> 
> In the dmesg I see a lot of PM messages. Did you do a suspend/resume or
> hibernate? Trying to determine the scenario so any more info is appreciated.

I think there was one suspend & resume cycle in between, triggered by
echo mem > /sys/power/state.

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
