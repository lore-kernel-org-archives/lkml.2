Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1E2SyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 14:54:13 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19550 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab1E2SyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 14:54:12 -0400
Date: Sun, 29 May 2011 20:46:23 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Shutdown hang on Thinkpad T510 - Disabling IRQ #??
Message-ID: <alpine.LNX.2.00.1105292030320.4411@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone

I've got a strange hang happening on shutdown sometimes on my Thinkpad 
T510 (Type 4384-GJG , BIOS version: 1.43 , ECP version: 1.19). 4GB RAM 
installed, CPU is a core i5 560M, graphics is the build-in Intel HD 
graphics, no discrete graphics card, 7200RPM 320GB HD.

Most of the time it shuts down perfectly, but once in a while it will hang 
after Arch Linux outputting it's "POWER OFF" message. When this happens it 
will always output one or more lines of "Disabling IRQ #??" where the "??" 
part is a IRQ number that varies, but 9, 17 and 19 are the most common 
ones.

One interresting observation is that the system comes preconfigured with 
all PCI IRQ's set to 11 in the BIOS and with this setting I get the 
shutdown hang in roughly one every 5-6 shutdowns. If I go into the BIOS 
and then change all the PCI IRQ assignments to AUTO then I still get the 
hang, but it is much less frequent - I'd guesstimate once every 20 
shutdowns.

A (very bad) photo I managed to take of this the last time it happened, in 
case it's any help, is available here: 
http://personal.chaosbits.net/shutdown-hang.jpg
(the last line of ^@^@^@ is just me trying various keys to get it to 
shutdown - including sysrq - but all it responds to is the powerbutton).

The kernel I was running at the time was 2.6.38.6 but it has happened with 
older kernels as well - it's been happening since I got the machine which 
was around 2.6.37.0 time.

At this point I'm not quite sure what to try in order to get rid of it, so 
advice on that is more than welcome. 

If there is any information I can provide that would help in tracking this 
down, please just let me know and I'll provide it if I can.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

