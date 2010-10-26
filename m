Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab0JZOTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:19:20 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:61954 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab0JZOTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:19:19 -0400
Date: Tue, 26 Oct 2010 16:19:05 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: Strange fsck messages showing up in dmesg
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: linux-kernel@vger.kernel.org, xen-users@lists.xensource.com
References: <201010260805.37501.thomas@fjellstrom.ca>
In-Reply-To: <201010260805.37501.thomas@fjellstrom.ca> (from
	thomas@fjellstrom.ca on Tue Oct 26 16:05:37 2010)
X-Mailer: Balsa 2.3.14
Message-Id: <1288102745l.15819l.2l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2010-10-26 16:05:37, Thomas Fjellstrom wrote:
> Recently on an Xen based system I've seen some odd messages show up in dmesg.
> 
> [3949276.262287] SGI XFS with ACLs, security attributes, realtime, large 
> block/inode numbers, no debug enabled
> [3949276.263130] SGI XFS Quota Management subsystem
> [3949276.276566] JFS: nTxBlock = 8192, nTxLock = 65536
> [3949276.297503] NTFS driver 2.1.29 [Flags: R/W MODULE].
> [3949276.333813] QNX4 filesystem 0.2.3 registered.
> [3949276.476177] Btrfs loaded
> [3949276.867188] EXT3-fs: INFO: recovery required on readonly filesystem.

etc.

Looks like fairly normal boot messages after an unclean shutdown (crash).

BTW: Which kernel version?  Is this the host or a guest?

Cheers
Anders

