Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab0D3RRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:17:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:49729 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932709Ab0D3RRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:17:09 -0400
X-Authenticated: #57309416
X-Provags-ID: V01U2FsdGVkX1+uZaBGBV+unVhvCLgO1FKGEsQ+/vJhhATGEXiPrk
	KWZMMWu6hQ393i
Message-ID: <4BDAD84C.4020800@gmx.de>
Date: Fri, 30 Apr 2010 15:17:00 +0200
From: =?ISO-8859-1?Q?Lukas_Gr=E4sslin?= <lukasgraesslin@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Nils Radtke <Nils.Radtke@Think-Future.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: iwlagn + some accesspoint = hardlock
References: <20100422093949.GC16001@localhost>
In-Reply-To: <20100422093949.GC16001@localhost>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I have _exactely_ the same problem as you.

=> http://www.mail-archive.com/arch-general@archlinux.org/msg12865.html

The strange thing here also is that I mostly only get these freezes when
I'm sitting on my veranda with the thinkpad via wlan. When I'm inside
the house I have no freezes.

This is very very strange, but I happy, that I'm not the only one with
this problem.

Would be nice if you have any news if you let me know,

Regards,
	Lukas

On 22.04.2010 11:39, Nils Radtke wrote:
>   Hello there,
> 
>  today a somewhat unprecise report:
> 
> When connecting to the local university's wireless APs, rather regularly 
> presumably the kernel crashes.
> 
> So, connecting to one of those the system hardlocks. No panic LED blinking, no mouse cursor moving, 
> no magic sysreq key working. Poweroff is the only way to revive the machine. Until the upcoming
> lock-up.
> 
> What might serve as a hint: using knemo and kwifimanager (with wpa_supplicant in the bg) it feels like it is 
> freezing more frequently. Not running kwifimanager seems to reduce the frequency w/o however eliminating it
> completely. Sometimes iceweasel has been touched and then the crash occurred. 
> Maybe some TX (or subsequent RX) provokes the crash? Some idea that also came up was that accessing iwlagn 
> drivers isn't clean when it's happening from more that one place at the same time 
> (->wpa_supplicant + kwifimanager)?
> 
> This behaviour is currently only known to happen in this exact place/location. So one assumption is that it
> is somehow correlated to a particular type of access point, firmware respectively. Nonetheless, even
> if there's some fw sending kill packets, the kernel should not crash, obviously.
> 
> The access points in range are of type:
> 
> - one 0:1d:8b PIRELLI BROADBAND SOLUTIONS 
> - couple of those 0:40:96 Cisco Systems, Inc.
> - one 0:1a:70 Cisco-Linksys
> 
> This notebook has no serial port, so we haven't been able to get a glimpse on what is happening at that 
> precise moment. xconsole or dmesg haven't been helpful as the system just freezes and that's it.
> 
> Comments, ideas, fixes welcome...
> 
> Cheers,
> 
>   Nils
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Lukas Grässlin
GnuPG-Key: http://lg.ath.cx/lukasgraesslin@gmx.de.asc
