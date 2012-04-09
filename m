Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab2DIPbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 11:31:07 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:61204 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375Ab2DIPbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 11:31:05 -0400
X-Greylist: delayed 1760 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Apr 2012 11:31:05 EDT
Date: Mon, 09 Apr 2012 17:01:36 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH/V3] [trivial] Documentation: Fix multiple typo in
 Documentation
To: Masanari Iida <standby24x7@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1333972735-12670-1-git-send-email-standby24x7@gmail.com> (from
	standby24x7@gmail.com on Mon Apr  9 13:58:55 2012)
X-Mailer: Balsa 2.4.1
Message-Id: <1333983696.3519.0@oscar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
References: <1333972735-12670-1-git-send-email-standby24x7@gmail.com>
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(at least) two more typos slipped by:

On 2012-04-09 13:58:55, Masanari Iida wrote:
[snip]
> diff --git a/Documentation/filesystems/qnx6.txt  
> b/Documentation/filesystems/qnx6.txt
> index 050223e..0708584 100644
> --- a/Documentation/filesystems/qnx6.txt
> +++ b/Documentation/filesystems/qnx6.txt
> @@ -17,7 +17,7 @@ concepts of blocks, inodes and directories.
>  On QNX it is possible to create little endian and big endian qnx6  
> filesystems.
>  This feature makes it possible to create and use a different  
> endianness fs
>  for the target (QNX is used on quite a range of embedded systems)  
> plattform
> -running on a different endianess.
> +running on a different endianness.
>  The Linux driver handles endianness transparently. (LE and BE)
> 
>  Blocks
> @@ -26,7 +26,7 @@ Blocks
>  The space in the device or file is split up into blocks. These are a  
> fixed
>  size of 512, 1024, 2048 or 4096, which is decided when the  
> filesystem is
>  created.
> -Blockpointers are 32bit, so the maximum space that can be adressed is
> +Blockpointers are 32bit, so the maximum space that can be addressed  
> is
>  2^32 * 4096 bytes or 16TB
> 
>  The superblocks
> @@ -47,16 +47,16 @@ inactive superblock.
>  Each superblock holds a set of root inodes for the different  
> filesystem
>  parts. (Inode, Bitmap and Longfilenames)
>  Each of these root nodes holds information like total size of the  
> stored
> -data and the adressing levels in that specific tree.
> -If the level value is 0, up to 16 direct blocks can be adressed by  
> each
> +data and the addressing levels in that specific tree.
> +If the level value is 0, up to 16 direct blocks can be addressed by  
> each
>  node.
> -Level 1 adds an additional indirect adressing level where each  
> indirect
> -adressing block holds up to blocksize / 4 bytes pointers to data  
> blocks.
> -Level 2 adds an additional indirect adressig block level (so,  
> already up
> -to 16 * 256 * 256 = 1048576 blocks that can be adressed by such a  
> tree)a
> +Level 1 adds an additional indirect addressing level where each  
> indirect
> +addressing block holds up to blocksize / 4 bytes pointers to data  
> blocks.
> +Level 2 adds an additional indirect addressig block level (so,  
> already up

s/addressig/addressing/

> +to 16 * 256 * 256 = 1048576 blocks that can be addressed by such a  
> tree)a

s/a$/./

> 
>  Unused block pointers are always set to ~0 - regardless of root node,
> -indirect adressing blocks or inodes.
> +indirect addressing blocks or inodes.
>  Data leaves are always on the lowest level. So no data is stored on  
> upper
>  tree levels.
> 
> @@ -64,7 +64,7 @@ The first Superblock is located at 0x2000. (0x2000  
> is the bootblock size)
>  The Audi MMI 3G first superblock directly starts at byte 0.
>  Second superblock position can either be calculated from the  
> superblock
>  information (total number of filesystem blocks) or by taking the  
> highest
> -device address, zeroing the last 3 bytes and then substracting  
> 0x1000 from
> +device address, zeroing the last 3 bytes and then subtracting 0x1000  
> from
>  that address.
> 
>  0x1000 is the size reserved for each superblock - regardless of the
> @@ -83,8 +83,8 @@ size, number of blocks used, access time, change  
> time and modification time.
>  Object mode field is POSIX format. (which makes things easier)
> 
>  There are also pointers to the first 16 blocks, if the object data  
> can be
> -adressed with 16 direct blocks.
> -For more than 16 blocks an indirect adressing in form of another  
> tree is
> +addressed with 16 direct blocks.
> +For more than 16 blocks an indirect addressing in form of another  
> tree is
>  used. (scheme is the same as the one used for the superblock root  
> nodes)
> 
>  The filesize is stored 64bit. Inode counting starts with 1. (whilst  
> long
> @@ -118,13 +118,13 @@ no block pointers and the directory file record  
> pointing to the target file
>  inode.
> 
>  Character and block special devices do not exist in QNX as those  
> files
> -are handled by the QNX kernel/drivers and created in /dev  
> independant of the
> +are handled by the QNX kernel/drivers and created in /dev  
> independent of the
>  underlaying filesystem.
> 
>  Long filenames
>  --------------
> 
> -Long filenames are stored in a seperate adressing tree. The staring  
> point
> +Long filenames are stored in a separate addressing tree. The staring  
> point
>  is the longfilename root node in the active superblock.
>  Each data block (tree leaves) holds one long filename. That filename  
> is
>  limited to 510 bytes. The first two starting bytes are used as  
> length field

Cheers
Anders
