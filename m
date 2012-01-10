Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2AJMQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 07:16:10 -0500
Received: from mother.openwall.net ([195.42.179.200]:62960 "EHLO openwall.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755314Ab2AJMQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 07:16:09 -0500
X-Greylist: delayed 1621 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jan 2012 07:16:08 EST
Date: Tue, 10 Jan 2012 15:49:05 +0400
From: "Dmitry D. Khlebnikov" <galaxy@openwall.com>
To: linux-kernel@vger.kernel.org
Subject: kernel 3.2 crashes too early on HP dc7700 and HP t5000 series
Message-ID: <20120110114905.GC13535@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've tried to test the recently released 3.2 version on a couple of my
PCs (one is HP dc7700, an SFF PC running on Intel E6300, another is HP
t5710 thin client running Transmeta's Efficeon).  In both cases the
kernel crashed during the first seconds the control was given to it by
the bootloader.

I decided to investigate, so I've compiled a version using 'make
allnoconfig' - and it has crashed with the same symptoms: once the
kernel gets the execution control a screen is filled up with random colour
rubbish and after 15 seconds or so my LCD turns off into the power
saving state.  The machine looks to be locked up since it doesn't react
on the keyboard.

Well, I thought that an early printk's may help me to determine what's
going on so I recompiled the kernel with them + a couple of other
debugging options (like x86 bootup debugging code), but after I rebooted
into the newly compiled kernel I got the very same lock-up.

Both these PCs are running fine with 3.1.5 and I'm now downloading
3.1.8 (just to confirm that 3.1 series are working on this hardware).

This message is just to notify the community that there is some issue
with 3.2 on old HP hardware.  I'll try to figure out what's wrong and if
I find anything I'll post a follow-up.

I'd appreciate any hints on how to debug this kind of crashes.  Right
now, I'm thinking re: adding some dirty debugging code into the kernel
initialisation just to figure out where it crashes.

Please include me into CC if you are going to reply to this message
since I'm not subscribed to LKML.

-- 
(GM)

