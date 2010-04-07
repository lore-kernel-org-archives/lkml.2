Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab0DGKQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 06:16:17 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36566 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab0DGKQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 06:16:10 -0400
Date: Wed, 7 Apr 2010 12:15:14 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jan III Sobieski <jan3sobi3ski@gmail.com>
Subject: Re: 2.6.34-rc2-git3 - missing =?utf-8?Q?pa?=
	=?utf-8?Q?tch_-_include=2Flinux=2Fpktcdvd=2Eh=3A166=3A_error=3A_field_?=
	=?utf-8?B?4oCYcmVhZF9xdWV1ZeKAmQ==?= has incomplete type
Message-ID: <20100407101514.GC12052@aftab>
References: <9c2470ce1003271202h65588454t995f204f60995e77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c2470ce1003271202h65588454t995f204f60995e77@mail.gmail.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan III Sobieski <jan3sobi3ski@gmail.com>
Date: Sat, Mar 27, 2010 at 08:02:34PM +0100

Linus,

can you please pick the patch up at the URL directly - it still triggers
on my randconfig builds.

> This patch is missing http://lkml.org/lkml/2010/2/25/425
> 
>   CC      fs/compat_ioctl.o
> In file included from fs/compat_ioctl.c:105:
> include/linux/pktcdvd.h:166: error: field ‘read_queue’ has incomplete type
> include/linux/pktcdvd.h:167: error: field ‘write_queue’ has incomplete type
> include/linux/pktcdvd.h:207: error: field ‘orig_bios’ has incomplete type

Thanks.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
