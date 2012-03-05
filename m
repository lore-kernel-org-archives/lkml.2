Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab2CERKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:10:31 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:37800 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755510Ab2CERK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:10:29 -0500
Message-ID: <4F54F38E.6050906@xenotime.net>
Date: Mon, 05 Mar 2012 09:10:38 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] [trivial] Documentation: Fix multiple typo in Documentation
References: <1330964693-29763-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1330964693-29763-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 08:24 AM, Masanari Iida wrote:

> Correct following typo within 25 files in Documentation.
> 
> "explaination" to "explanation" in dmaengine.txt
> "fucntion" to "function" in static-keys.txt
> "useage" to "usage" in arm/kernel_user_helpers.txt
> "tranfer" to "transfer" in DocBook/libata.tmpl
> "devided" to "divided" in filesystems/qnx6.txt
> "appropriatly" to "appropriately" in i2o/ioctl
> "ususally" to "usually" in input/alps.txt
> "ocassionally" to "occasionally" in input/alps.txt
> "Ths" to "This" in scsi/ChangeLog.megaraid_sas
> "preceeded" to "preceded" in virtual/virtio-spec.txt
> "guarentees" to "guarantees" in virtual/virtio-spec.txt
> "withdrawl" to "withdrawal" in virtual/virtio-spec.txt
> "independantly" to "independently" in video4linux/uvcvideo.txt
> "Licenced" to "Licensed" in laptops/dslm.c
> "adress" to "address" in filesystems/qnx6.txt
> "Millenium" to "Millennium" in filesystems/qnx6.txt,
>   fb/matrixfb.txt, howmon/adm1275, hwmon/max16064,
>   hwmon/max34440, hwmon/max8688, hwmon/ucd9000, hwmon/ucd9200,
>   hwmon/zl6100, scsi/tmscsim.txt, input/joystick.txt
> "endianess" to "endianness" in filesystems/qnx6.txt,
>   ioctl/hdio.txt, networking/fore200e.txt,
>   ide/ChangeLog.ide-cd.1994-2004
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> 
> ---
>  Documentation/DocBook/libata.tmpl            |    4 ++--
>  Documentation/arm/kernel_user_helpers.txt    |    2 +-
>  Documentation/dmaengine.txt                  |    2 +-
>  Documentation/fb/matroxfb.txt                |    6 +++---
>  Documentation/filesystems/qnx6.txt           |   26 +++++++++++++-------------
>  Documentation/hwmon/adm1275                  |    2 +-
>  Documentation/hwmon/max16064                 |    4 ++--
>  Documentation/hwmon/max34440                 |    4 ++--
>  Documentation/hwmon/max8688                  |    4 ++--
>  Documentation/hwmon/ucd9000                  |    6 +++---
>  Documentation/hwmon/ucd9200                  |    8 ++++----
>  Documentation/hwmon/zl6100                   |    4 ++--
>  Documentation/i2o/ioctl                      |   12 ++++++------
>  Documentation/ide/ChangeLog.ide-cd.1994-2004 |    2 +-
>  Documentation/input/alps.txt                 |    4 ++--
>  Documentation/input/joystick.txt             |    2 +-
>  Documentation/ioctl/hdio.txt                 |    4 ++--
>  Documentation/laptops/dslm.c                 |    2 +-
>  Documentation/networking/fore200e.txt        |    2 +-
>  Documentation/scsi/ChangeLog.lpfc            |    2 +-
>  Documentation/scsi/ChangeLog.megaraid_sas    |    2 +-
>  Documentation/scsi/tmscsim.txt               |    2 +-
>  Documentation/static-keys.txt                |    2 +-
>  Documentation/video4linux/uvcvideo.txt       |    2 +-
>  Documentation/virtual/virtio-spec.txt        |    8 ++++----
>  25 files changed, 59 insertions(+), 59 deletions(-)

> diff --git a/Documentation/fb/matroxfb.txt b/Documentation/fb/matroxfb.txt
> index e5ce8a1..a75cf19 100644
> --- a/Documentation/fb/matroxfb.txt
> +++ b/Documentation/fb/matroxfb.txt
> @@ -204,7 +204,7 @@ grayscale - enable grayscale summing. It works in PSEUDOCOLOR modes (text,
>  	    can paint colors.
>  nograyscale - disable grayscale summing. It is default.
>  cross4MB - enables that pixel line can cross 4MB boundary. It is default for
> -           non-Millenium.
> +           non-Millennium.
>  nocross4MB - pixel line must not cross 4MB boundary. It is default for
>               Millenium I or II, because of these devices have hardware


                Millennium

>  	     limitations which do not allow this. But this option is
> diff --git a/Documentation/filesystems/qnx6.txt b/Documentation/filesystems/qnx6.txt
> index 050223e..1a2e929 100644
> --- a/Documentation/filesystems/qnx6.txt
> +++ b/Documentation/filesystems/qnx6.txt
> @@ -47,16 +47,16 @@ inactive superblock.
>  Each superblock holds a set of root inodes for the different filesystem
>  parts. (Inode, Bitmap and Longfilenames)
>  Each of these root nodes holds information like total size of the stored
> -data and the adressing levels in that specific tree.
> -If the level value is 0, up to 16 direct blocks can be adressed by each
> +data and the addressing levels in that specific tree.
> +If the level value is 0, up to 16 direct blocks can be addressed by each
>  node.
> -Level 1 adds an additional indirect adressing level where each indirect
> -adressing block holds up to blocksize / 4 bytes pointers to data blocks.
> -Level 2 adds an additional indirect adressig block level (so, already up
> -to 16 * 256 * 256 = 1048576 blocks that can be adressed by such a tree)a
> +Level 1 adds an additional indirect addressing level where each indirect
> +addressing block holds up to blocksize / 4 bytes pointers to data blocks.
> +Level 2 adds an additional indirect addressig block level (so, already up


                                       addressing

> +to 16 * 256 * 256 = 1048576 blocks that can be addressed by such a tree)a
>  


> @@ -148,7 +148,7 @@ smaller than addressing space in the bitmap.
>  Bitmap system area
>  ------------------
>  
> -The bitmap itself is devided into three parts.
> +The bitmap itself is divided into three parts.
>  First the system area, that is split into two halfs.


                                                 halves.

>  Then userspace.
>  

> diff --git a/Documentation/ide/ChangeLog.ide-cd.1994-2004 b/Documentation/ide/ChangeLog.ide-cd.1994-2004
> index 190d17b..b2cf804 100644
> --- a/Documentation/ide/ChangeLog.ide-cd.1994-2004
> +++ b/Documentation/ide/ChangeLog.ide-cd.1994-2004
> @@ -175,7 +175,7 @@
>   *                         since the .pdf version doesn't seem to work...
>   *                     -- Updated the TODO list to something more current.
>   *
> - * 4.15  Aug 25, 1998  -- Updated ide-cd.h to respect mechine endianess,
> + * 4.15  Aug 25, 1998  -- Updated ide-cd.h to respect mechine endianness,


                                                         machine

>   *                         patch thanks to "Eddie C. Dost" <ecd@skynet.be>
>   *
>   * 4.50  Oct 19, 1998  -- New maintainers!

> diff --git a/Documentation/input/joystick.txt b/Documentation/input/joystick.txt
> index 8007b7c..87ac40c 100644
> --- a/Documentation/input/joystick.txt
> +++ b/Documentation/input/joystick.txt
> @@ -330,7 +330,7 @@ the USB documentation for how to setup an USB mouse.
>    The TM DirectConnect (BSP) protocol is supported by the tmdc.c
>  module. This includes, but is not limited to:
>  
> -* ThrustMaster Millenium 3D Inceptor
> +* ThrustMaster Millennium 3D Inceptor


                                Interceptor

>  * ThrustMaster 3D Rage Pad
>  * ThrustMaster Fusion Digital Game Pad
>  


> diff --git a/Documentation/laptops/dslm.c b/Documentation/laptops/dslm.c
> index 72ff290..d5dd2d4 100644
> --- a/Documentation/laptops/dslm.c
> +++ b/Documentation/laptops/dslm.c
> @@ -2,7 +2,7 @@
>   * dslm.c
>   * Simple Disk Sleep Monitor
>   *  by Bartek Kania
> - * Licenced under the GPL


above is OK.

> + * Licensed under the GPL
>   */
>  #include <unistd.h>
>  #include <stdlib.h>



Thanks.
---
~Randy

