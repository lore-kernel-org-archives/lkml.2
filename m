Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab1F0Vt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:49:29 -0400
Received: from lucidpixels.com ([72.73.18.11]:56109 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191Ab1F0VtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:49:00 -0400
Date: Mon, 27 Jun 2011 17:48:59 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: e1000-devel@lists.sourceforge.net
Subject: 2.6.39.2: skb_over_panic: kernel BUG at net/core/skbuff.c:127!
Message-ID: <alpine.DEB.2.02.1106271742310.6721@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks like I am not the first one:
https://bugzilla.redhat.com/show_bug.cgi?id=429868

Any thoughts on this one?
http://home.comcast.net/~jpiszcz/20110627/IMG_2703.JPG

Rough transcription:

skb_over_panic: text:ffffffff813d711c len:44117 put:44117 head:ffff880415d40000 data:ffff880415d40040 tail:0xac95 end:0x640 dev:eth2
-- [ cut here ] ---
kernel BUG at net/core/skbuff.c:127!
invalid opcode: 0000 [#1] SMP

Was playing a video over samba (eth0) and then the kernel panic'd on eth2?

I use all INTEL controllers:

00:19.0 Ethernet controller: Intel Corporation 82578DC Gigabit Network Connection (rev 05)
01:00.0 Ethernet controller: Intel Corporation 82598EB 10-Gigabit AT2 Server Adapter (rev 01)
03:00.0 Ethernet controller: Intel Corporation 82580 Gigabit Network Connection (rev 01)
03:00.1 Ethernet controller: Intel Corporation 82580 Gigabit Network Connection (rev 01)
03:00.2 Ethernet controller: Intel Corporation 82580 Gigabit Network Connection (rev 01)
03:00.3 Ethernet controller: Intel Corporation 82580 Gigabit Network Connection (rev 01)

Justin.

