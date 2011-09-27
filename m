Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab1I0Vqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:46:32 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21255 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab1I0Vqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:46:30 -0400
To: Arun <engineerarun@gmail.com>
Cc: Mark Knecht <markknecht@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Joshua Scoggins <theoretically.x64@gmail.com>,
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
	<yq11uv1dd6h.fsf@sermon.lab.mkp.net>
	<CAK2H+eeJGjMVCTAf=UDmozDK+MJUCM-HfuzuiBvuqZwSeiQzNw@mail.gmail.com>
	<CANLaLhZZdw9Wedc39VoEvpK1Xw-EXTFPD9JXsu1nJd3s8sTb2Q@mail.gmail.com>
Date: Tue, 27 Sep 2011 17:44:25 -0400
In-Reply-To: <CANLaLhZZdw9Wedc39VoEvpK1Xw-EXTFPD9JXsu1nJd3s8sTb2Q@mail.gmail.com>
	(Arun's message of "Wed, 28 Sep 2011 02:42:28 +0530")
Message-ID: <yq1pqilbqyu.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E82442E.00C3:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Arun" == Arun  <engineerarun@gmail.com> writes:

Arun> A quick check of hdparm tells me that it is using the SG_IO ioctl
Arun> for the ATA_OP_PIDENTIFY command. Maybe I have some hopes of
Arun> having a correct result with the BLKPBSZGET ioctl. Will check that
Arun> out.

hdparm and the kernel are looking the same place for the physical block
size. There should be no discrepancy between what hdparm can see and
what's reported in physical_block_size by the kernel. The BLKPBSZGET
returns the same topology parameter as sysfs' physical_block_size.

-- 
Martin K. Petersen	Oracle Linux Engineering
