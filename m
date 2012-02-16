Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab2BPTOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:14:33 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:32384 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab2BPTOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:14:32 -0500
To: Arun <engineerarun@gmail.com>
Cc: NamJae Jeon <linkinjeon@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mark Knecht <markknecht@gmail.com>,
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
	<yq1pqilbqyu.fsf@sermon.lab.mkp.net>
	<CAKYAXd9KwRGs3+hLxisWv=+X7fupMF0txUjGx4N9Tryn12OpaA@mail.gmail.com>
	<CANLaLhagmNFFrNxC88cyPqsx_j+-Y-WaAUCQpkR57z264Bn6Vw@mail.gmail.com>
Date: Thu, 16 Feb 2012 14:14:19 -0500
In-Reply-To: <CANLaLhagmNFFrNxC88cyPqsx_j+-Y-WaAUCQpkR57z264Bn6Vw@mail.gmail.com>
	(Arun's message of "Fri, 17 Feb 2012 00:36:08 +0530")
Message-ID: <yq1pqdea8vo.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F3D5590.011C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Arun" == Arun  <engineerarun@gmail.com> writes:

Arun> [...] couldn't find any direct way of detecting an SSD drive like
Arun> an ioctl.

Arun> Is there any such direct way of detecting SSD drives yet? I am
Arun> working on kernel version 2.6.32-19.

You can check /sys/block/foo/queue/rotational.

The matching BLKROTATIONAL ioctl didn't go in until very recently.

-- 
Martin K. Petersen	Oracle Linux Engineering
