Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab0DVA3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 20:29:48 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:54998
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752068Ab0DVA3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 20:29:46 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz936eMzz1202hzzz2fh2a8h61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4BCF9863.2000903@am.sony.com>
Date: Wed, 21 Apr 2010 17:29:23 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: squashfs-devel@lists.sourceforge.net
CC: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Status of SquashFS LZMA support in mainline
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anyone (Phillip?) know the status of SquashFS support
for LZMA compression in mainline?  I seem to recall that
Phillip got the patches for this into linux-next sometime
in January, but I'm not sure if the latest kernel
(2.6.34-rcxx) includes this or not.

I also see in Linus' git tree the following commits in
March:

2010-03-05	Linus Torvalds	Merge git://git.kernel.org/pub/scm/linux/kernel/git...
...git://git./linux/kernel/git/pkl/squashfs-linus
...org/pub/scm/linux/kernel/git/pkl/squashfs-linus:
Squashfs: get rid of obsolete definition...
Squashfs: get rid of obsolete variable...
Squashfs: add decompressor entries for...
Squashfs: add a decompressor framework
Squashfs: factor out remaining zlib dependencies...
Squashfs: move zlib decompression wrapper...


2010-03-05	Phillip Lougher	Squashfs: get rid of obsolete variable in struct squashfs_sb...
Squashfs: get rid of obsolete variable...

Is this everything, or are there still things outstanding?
In January the V3 patches were labeled:
lzma: Make lzma available to non initramfs/initrd code
lzma: make lzma reentrant

The first one of these modifies lib/Kconfig, but I don't
see a change (in git) authored by Phillip in this time frame.

Thanks for any information you can provide.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Network Entertainment
=============================

