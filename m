Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0LNOst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:48:49 -0500
Received: from zinan.dashjr.org ([173.242.112.54]:36638 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab0LNOss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:48:48 -0500
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Dec 2010 09:48:48 EST
From: "Luke-Jr" <luke@dashjr.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: 6to4/Teredo IPv4 matching
Date: Tue, 14 Dec 2010 09:40:07 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r1; KDE/4.4.5; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
X-PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
X-PGP-Key-ID: 665FC11DD53E9583
X-PGP-Keyserver: x-hkp://subkeys.pgp.bet
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012140940.11119.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are there any plans to allow matching 6to4/Teredo IPv6 packets against IPv4 
rules (or at least ipsets)? Recently I have a server that's been under 
constant DDoS from China, and I found that when I use ipsets to drop 
everything from China, some continue to hammer my server over 6to4 and/or 
Teredo. So I just figured I'd throw the idea out there in case it hasn't 
occurred to anyone yet. ;)
