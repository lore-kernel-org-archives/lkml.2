Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1I0TBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 15:01:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30141 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1I0TB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 15:01:29 -0400
To: Arun <engineerarun@gmail.com>
Cc: Joshua Scoggins <theoretically.x64@gmail.com>,
        Mike Snitzer <snitzer@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: Detection of Advanced Format drives
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <CANLaLhaEnyPchqOPp65Y0hvotM30E5daX=XNG=fAAmf1dchxCA@mail.gmail.com>
	<20110926111522.2a053ceb@lxorguk.ukuu.org.uk>
	<CAK3HsqvkpEiDWcCP_+eO0va4+io7pVV-aWCzQ1=DdpPi_jxy6g@mail.gmail.com>
	<CAMM=eLdTkpV_oy7+N2QVeqmm4t0WkAJXUmGkxWcb=X8Vp81x7A@mail.gmail.com>
	<CAK3HsqtdgqWB36NCxz0xZxTrfp2-o8b7MYncn_P61eUv2xkAkw@mail.gmail.com>
	<CANLaLhbiLC-+azrdmf3_uPYS1zR3x-Yk9tA2b0U6_z72YSjQYQ@mail.gmail.com>
Date: Tue, 27 Sep 2011 14:59:18 -0400
In-Reply-To: <CANLaLhbiLC-+azrdmf3_uPYS1zR3x-Yk9tA2b0U6_z72YSjQYQ@mail.gmail.com>
	(Arun's message of "Wed, 28 Sep 2011 00:06:16 +0530")
Message-ID: <yq11uv1dd6h.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090201.4E821D80.008D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Arun" == Arun  <engineerarun@gmail.com> writes:

Arun> Should I suppose that it is an already available piece of
Arun> information to the userland? 

Yes, in the sysfs locations Mike mentioned:

  /sys/block/foo/queue/physical_block_size

Or you can use the BLKPBSZGET ioctl.


Arun> Or do I need to modify the hdparm/fdisk code to get this piece of
Arun> info?

Recent hdparm versions will also report the right thing:

# hdparm -I /dev/sdc | grep Sector
        Logical  Sector size:                   512 bytes
        Physical Sector size:                  4096 bytes
        Logical Sector-0 offset:                512 bytes

-- 
Martin K. Petersen	Oracle Linux Engineering
