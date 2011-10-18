Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab1JRJEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:04:39 -0400
Received: from a.relay.invitel.net ([62.77.203.3]:51848 "EHLO
	a.relay.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145Ab1JRJEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:04:38 -0400
Date: Tue, 18 Oct 2011 11:04:36 +0200
From: =?iso-8859-1?B?R+Fib3IgTOlu4XJ0?= <lgb@lgb.hu>
To: linux-kernel@vger.kernel.org
Subject: Re: barrier-based sync failed - disabling barriers
Message-ID: <20111018090436.GB21728@vega.lgb.hu>
Reply-To: lgb@lgb.hu
References: <20111018081159.GA21728@vega.lgb.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111018081159.GA21728@vega.lgb.hu>
X-Operating-System: vega Linux 2.6.38-12-generic i686
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 10:11:59AM +0200, Gábor Lénárt wrote:
> I have a kernel log entry I've never seen before:
> 
> JBD: barrier-based sync failed on cciss!c0d0p3-8 - disabling barriers
> JBD: barrier-based sync failed on cciss!c0d0p1-8 - disabling barriers
> 
> Should I worry? Can it be blamed for the poor I/O performance? How can I
> solve this problem? Even if it doesn't mean too much (what I should
> worry about), it's a bit annoying (as always) to see odd messages.
> 
> The ext4 filesystems were created by the installer of an older (ubuntu)
> distribution, I guess, it can cause problems after the upgrade. Can I
> convert/modify the filesystem (like with tune2fs) not to have these
> messages and problem?


Sorry, I forgot to give some information:

Linux nopea1 2.6.32-34-server #77-Ubuntu SMP Tue Sep 13 20:54:38 UTC 2011 x86_64 GNU/Linux
Ubuntu 10.04.3 LTS "lucid"
Hardware name: ProLiant DL360 G5
/dev/cciss/c0d0: (Smart Array E200i) RAID 1 Volume 0 status: OK. 

Filesystem volume name:   /
Last mounted on:          /
Filesystem UUID:          06a107ec-cf2a-4dca-bb95-ab7745402f5b
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent flex_bg sparse_super large_file huge_file
uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              610800
Block count:              2441876
Reserved block count:     0
Free blocks:              2079823
Free inodes:              577158
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      596
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8144
Inode blocks per group:   509
Flex block group size:    16
Filesystem created:       Wed Oct 12 17:24:42 2011
Last mount time:          Tue Oct 18 10:01:29 2011
Last write time:          Wed Oct 12 19:39:53 2011
Mount count:              6
Maximum mount count:      35
Last checked:             Wed Oct 12 17:24:42 2011
Check interval:           15552000 (6 months)
Next check after:         Mon Apr  9 17:24:42 2012
Lifetime writes:          833 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      0914f7b2-bfa3-4718-811d-fc02c7361b32
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             128M
Journal length:           32768
Journal sequence:         0x0000055a
Journal start:            1


- Gábor
