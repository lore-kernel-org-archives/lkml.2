Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1I0TSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 15:18:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34741 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1I0TSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 15:18:47 -0400
MIME-Version: 1.0
In-Reply-To: <yq11uv1dd6h.fsf@sermon.lab.mkp.net>
References: <CANLaLhaEnyPchqOPp65Y0hvotM30E5daX=XNG=fAAmf1dchxCA@mail.gmail.com>
	<20110926111522.2a053ceb@lxorguk.ukuu.org.uk>
	<CAK3HsqvkpEiDWcCP_+eO0va4+io7pVV-aWCzQ1=DdpPi_jxy6g@mail.gmail.com>
	<CAMM=eLdTkpV_oy7+N2QVeqmm4t0WkAJXUmGkxWcb=X8Vp81x7A@mail.gmail.com>
	<CAK3HsqtdgqWB36NCxz0xZxTrfp2-o8b7MYncn_P61eUv2xkAkw@mail.gmail.com>
	<CANLaLhbiLC-+azrdmf3_uPYS1zR3x-Yk9tA2b0U6_z72YSjQYQ@mail.gmail.com>
	<yq11uv1dd6h.fsf@sermon.lab.mkp.net>
Date: Wed, 28 Sep 2011 00:48:46 +0530
Message-ID: <CANLaLhYrnt-UEcQ04h=BZF1R6FSDDGg8MsDebPixHti9Hk6OJA@mail.gmail.com>
Subject: Re: Detection of Advanced Format drives
From: Arun <engineerarun@gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Joshua Scoggins <theoretically.x64@gmail.com>,
        Mike Snitzer <snitzer@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for confirming "hdparm -I" Martin... I guessed it would resolve
my detection problem but was not quite sure as I'm still waiting to
get the drive and had some time to get my hands dirty :)

Thanks everyone for taking interest in my problem.

Regards,

Arun



On Wed, Sep 28, 2011 at 00:29, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Arun" == Arun  <engineerarun@gmail.com> writes:
>
> Arun> Should I suppose that it is an already available piece of
> Arun> information to the userland?
>
> Yes, in the sysfs locations Mike mentioned:
>
>  /sys/block/foo/queue/physical_block_size
>
> Or you can use the BLKPBSZGET ioctl.
>
>
> Arun> Or do I need to modify the hdparm/fdisk code to get this piece of
> Arun> info?
>
> Recent hdparm versions will also report the right thing:
>
> # hdparm -I /dev/sdc | grep Sector
>        Logical  Sector size:                   512 bytes
>        Physical Sector size:                  4096 bytes
>        Logical Sector-0 offset:                512 bytes
>
> --
> Martin K. Petersen      Oracle Linux Engineering
>
