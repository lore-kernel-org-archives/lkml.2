Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab2DQVJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 17:09:19 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:33969 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750851Ab2DQVJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 17:09:18 -0400
Message-ID: <4F8DDC22.8050306@xenotime.net>
Date: Tue, 17 Apr 2012 14:09:54 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/V4] [trivial] Documentation: Fix typo in multiple files
 in Documentation
References: <1333983696.3519.0@oscar> <1333984933-15328-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1333984933-15328-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 08:22 AM, Masanari Iida wrote:

> Correct multiple spelling typo in Documentation.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> Acked-by: Rob Landley <rob@landley.net>
> Reported-by: Anders Larsen <al@alarsen.net>
> ---
>  Documentation/ABI/testing/sysfs-bus-usb            |    4 +--
>  Documentation/DocBook/kernel-hacking.tmpl          |    2 +-
>  Documentation/DocBook/libata.tmpl                  |    2 +-
>  Documentation/DocBook/media/v4l/controls.xml       |    6 ++---
>  Documentation/blackfin/bfin-gpio-notes.txt         |    2 +-
>  .../devicetree/bindings/net/can/fsl-flexcan.txt    |    2 +-
>  Documentation/dvb/opera-firmware.txt               |    4 +--
>  Documentation/edac.txt                             |    2 +-
>  Documentation/filesystems/nfs/pnfs.txt             |    2 +-
>  Documentation/filesystems/qnx6.txt                 |   28 ++++++++++----------
>  Documentation/hwmon/it87                           |    2 +-
>  Documentation/memory-hotplug.txt                   |    2 +-
>  Documentation/networking/can.txt                   |    2 +-
>  Documentation/parisc/debugging                     |    2 +-
>  Documentation/sound/alsa/compress_offload.txt      |    2 +-
>  Documentation/static-keys.txt                      |    2 +-
>  16 files changed, 33 insertions(+), 33 deletions(-)



> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index b84f25e..dd03cf4 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -2183,7 +2183,7 @@ Applicable to the MPEG4 and H264 encoders.</entry>
>  		<entry>integer</entry>
>  	      </row>
>  	      <row><entry spanname="descr">The Video Buffer Verifier size in kilobytes, it is used as a limitation of frame skip.
> -The VBV is defined in the standard as a mean to verify that the produced stream will be succesfully decoded.
> +The VBV is defined in the standard as a mean to verify that the produced stream will be successfully decoded.


                                           means ?

>  The standard describes it as "Part of a hypothetical decoder that is conceptually connected to the
>  output of the encoder. Its purpose is to provide a constraint on the variability of the data rate that an
>  encoder or editing process may produce.".
> @@ -2196,7 +2196,7 @@ Applicable to the MPEG1, MPEG2, MPEG4 encoders.</entry>
>  		<entry>integer</entry>
>  	      </row>
>  	      <row><entry spanname="descr">The Coded Picture Buffer size in kilobytes, it is used as a limitation of frame skip.
> -The CPB is defined in the H264 standard as a mean to verify that the produced stream will be succesfully decoded.
> +The CPB is defined in the H264 standard as a mean to verify that the produced stream will be successfully decoded.


                                                means ?

>  Applicable to the H264 encoder.</entry>
>  	      </row>
>  
> diff --git a/Documentation/filesystems/qnx6.txt b/Documentation/filesystems/qnx6.txt
> index 050223e..e59f2f0 100644
> --- a/Documentation/filesystems/qnx6.txt
> +++ b/Documentation/filesystems/qnx6.txt
> @@ -118,13 +118,13 @@ no block pointers and the directory file record pointing to the target file
>  inode.
>  
>  Character and block special devices do not exist in QNX as those files
> -are handled by the QNX kernel/drivers and created in /dev independant of the
> +are handled by the QNX kernel/drivers and created in /dev independent of the
>  underlaying filesystem.


   underlying ?

>  
>  Long filenames
>  --------------
>  
> -Long filenames are stored in a seperate adressing tree. The staring point
> +Long filenames are stored in a separate addressing tree. The staring point


                                                                starting

>  is the longfilename root node in the active superblock.
>  Each data block (tree leaves) holds one long filename. That filename is
>  limited to 510 bytes. The first two starting bytes are used as length field


