Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab2ASSIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 13:08:11 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34546 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab2ASSIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 13:08:07 -0500
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Dmitry D. Khlebnikov" <galaxy@openwall.com>
Subject: Re: kernel 3.2 crashes too early on HP dc7700 and HP t5000 series
Date: Thu, 19 Jan 2012 19:08:01 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20120110114905.GC13535@openwall.com>
In-Reply-To: <20120110114905.GC13535@openwall.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201191908.01122.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 10 stycznia 2012 o 12:49:05 Dmitry D. Khlebnikov wrote:
> Hello,
> 
> I've tried to test the recently released 3.2 version on a couple of my
> PCs (one is HP dc7700, an SFF PC running on Intel E6300, another is HP
> t5710 thin client running Transmeta's Efficeon).  In both cases the
> kernel crashed during the first seconds the control was given to it by
> the bootloader.
> 
> I decided to investigate, so I've compiled a version using 'make
> allnoconfig' - and it has crashed with the same symptoms: once the
> kernel gets the execution control a screen is filled up with random colour
> rubbish and after 15 seconds or so my LCD turns off into the power
> saving state.  The machine looks to be locked up since it doesn't react
> on the keyboard.
> 
> Well, I thought that an early printk's may help me to determine what's
> going on so I recompiled the kernel with them + a couple of other
> debugging options (like x86 bootup debugging code), but after I rebooted
> into the newly compiled kernel I got the very same lock-up.
> 
> Both these PCs are running fine with 3.1.5 and I'm now downloading
> 3.1.8 (just to confirm that 3.1 series are working on this hardware).
> 
> This message is just to notify the community that there is some issue
> with 3.2 on old HP hardware.  I'll try to figure out what's wrong and if
> I find anything I'll post a follow-up.
> 
> I'd appreciate any hints on how to debug this kind of crashes.  Right
> now, I'm thinking re: adding some dirty debugging code into the kernel
> initialisation just to figure out where it crashes.
> 
> Please include me into CC if you are going to reply to this message
> since I'm not subscribed to LKML.

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=42611
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.mrutecki.pl
