Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab1JSNJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 09:09:29 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:58529 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab1JSNJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 09:09:28 -0400
Date: Wed, 19 Oct 2011 15:09:23 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        Nico Schottelius <nico-linux-20111017@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
Message-ID: <20111019130923.GA5382@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
References: <20111019123602.GA11883@schottelius.org>
 <1319028563.8416.1.camel@edumazet-laptop>
 <4E9EC96E.8020303@broadcom.com>
 <1319029529.8416.3.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319029529.8416.3.camel@edumazet-laptop>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.1.0-rc6-gbee709a x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet [Wed, Oct 19, 2011 at 03:05:29PM +0200]:
> [...]
> make menuconfig
>  -> Kernel hacking
>    -> Lock debugging: prove locking correctness

Alright, rebuilding.

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
