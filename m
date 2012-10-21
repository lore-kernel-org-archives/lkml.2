Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2JUMa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 08:30:26 -0400
Received: from smtprelay0062.b.hostedemail.com ([64.98.42.62]:54634 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753228Ab2JUMaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 08:30:17 -0400
X-Panda: scanned!
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::::::::::,RULES_HIT:152:355:379:541:582:599:601:857:945:946:967:973:988:989:1152:1260:1277:1311:1313:1314:1345:1358:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2561:2564:2682:2685:2857:2859:2892:2933:2937:2939:2942:2945:2947:2951:2954:3022:3027:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3869:3870:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:5007:6261:7679:7689:7903:9025:10004:10400:10848:11658:11914:12043:12350:12517:12519:12679:12698:12737,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 2340
Date: Sun, 21 Oct 2012 12:30:15 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: zonque@gmail.com
Cc: bp@alien8.de, pavel@ucw.cz, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, security@kernel.org,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Message-ID: <317435358.100327.1350822615555.JavaMail.mail@webmail20>
References: <2104474742.26357.1350734815286.JavaMail.mail@webmail05>
 <20121020162759.GA12551@liondog.tnic>
 <966148591.30347.1350754909449.JavaMail.mail@webmail08>
 <20121020203227.GC555@elf.ucw.cz> <20121020225849.GA8976@liondog.tnic>
 <1781795634.31179.1350774917965.JavaMail.mail@webmail04>
 <20121021002424.GA16247@liondog.tnic>
 <1798605268.19162.1350784641831.JavaMail.mail@webmail17>
 <20121021110851.GA6504@liondog.tnic>
 <121566322.100103.1350820776893.JavaMail.mail@webmail20>
 <5083E4AA.3060807@gmail.com>
Subject: Re: Re: A reliable kernel panic (3.6.2) and system crash when
 visiting a particular website
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.77.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 21, 2012, Daniel Mack wrote: 

> A hint at least. How did you enable the audio record exactly? Can you
> reproduce this with arecord?
> 
> What chipset are you on? Please provide both "lspci -v" and "lsusb -v"
> dumps. As I said, I fail to reproduce that issue on any of my machines.

All other applications can read from the USB audio without problems, it's
just something in the way Adobe Flash polls my audio input which causes
a crash.

Just video capture (without audio) works just fine in Adobe Flash.

Only and only when I choose to use 

USB Device 0x46d:0x81d my system crashes in Adobe Flash.

See the screenshot:

https://bugzilla.kernel.org/attachment.cgi?id=84151

My hardware information can be fetched from here:

https://bugzilla.kernel.org/show_bug.cgi?id=49181

On a second thought that can be even an ALSA crash or pretty much
anything else.
