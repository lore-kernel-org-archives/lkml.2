Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506Ab0JZOYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:24:11 -0400
Received: from tomasu.net ([64.85.170.234]:37271 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758239Ab0JZOYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:24:09 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: Anders Larsen <al@alarsen.net>
Subject: Re: Strange fsck messages showing up in dmesg
Date: Tue, 26 Oct 2010 08:24:05 -0600
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
Cc: linux-kernel@vger.kernel.org, xen-users@lists.xensource.com
References: <201010260805.37501.thomas@fjellstrom.ca> <1288102745l.15819l.2l@i-dmzi_al.realan.de>
In-Reply-To: <1288102745l.15819l.2l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010260824.05826.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On October 26, 2010, Anders Larsen wrote:
> Hi,
> 
> On 2010-10-26 16:05:37, Thomas Fjellstrom wrote:
> > Recently on an Xen based system I've seen some odd messages show up in
> > dmesg.
> > 
> > [3949276.262287] SGI XFS with ACLs, security attributes, realtime, large
> > block/inode numbers, no debug enabled
> > [3949276.263130] SGI XFS Quota Management subsystem
> > [3949276.276566] JFS: nTxBlock = 8192, nTxLock = 65536
> > [3949276.297503] NTFS driver 2.1.29 [Flags: R/W MODULE].
> > [3949276.333813] QNX4 filesystem 0.2.3 registered.
> > [3949276.476177] Btrfs loaded
> > [3949276.867188] EXT3-fs: INFO: recovery required on readonly filesystem.
> 
> etc.
> 
> Looks like fairly normal boot messages after an unclean shutdown (crash).
> 
> BTW: Which kernel version?  Is this the host or a guest?

debian's 2.6.32-5-xen-amd64.

This is the host/Dom0. Thats after about 45 days of uptime. None of those 
devices are set to mount in the host by any conventional means.

> Cheers
> Anders


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
