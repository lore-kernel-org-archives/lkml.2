Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab1AHKCt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 05:02:49 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:33584 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab1AHKCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 05:02:46 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <00c801cba463$b0f3db00$12db9100$@mprc.pku.edu.cn> <201101070055.53996.arnd@arndb.de>
In-Reply-To: <201101070055.53996.arnd@arndb.de>
Subject: RE: [PATCHv1 02/12] unicore32 core architecture: generic headers stuff
Date: Sat, 8 Jan 2011 18:02:41 +0800
Message-ID: <023a01cbaf1b$3022b5b0$90682110$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIYK12dfRgBJd2P21ZajbE/j/EKgAEdxNtBkyTs8vA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Friday, January 07, 2011 7:56 AM
> To: Guan Xuetao
> Cc: linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCHv1 02/12] unicore32 core architecture: generic headers stuff
> 
> On Saturday 25 December 2010, Guan Xuetao wrote:
> > diff --git a/arch/unicore32/include/asm/sizes.h b/arch/unicore32/include/asm/sizes.h
> > new file mode 100644
> > index 0000000..3720307
> > --- /dev/null
> > +++ b/arch/unicore32/include/asm/sizes.h
> > @@ -0,0 +1,47 @@
> > +/*
> > + * linux/arch/unicore32/include/asm/sizes.h
> > + *
> > + * Code specific to PKUnity SoC and UniCore ISA
> > + *
> > + * Copyright (C) 2001-2010 GUAN Xue-tao
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +#ifndef __UNICORE_SIZES_H__
> > +#define __UNICORE_SIZES_H__
> > +
> > +/* handy sizes */
> > +#define SZ_16				0x00000010
> > +#define SZ_256				0x00000100
> > +#define SZ_512				0x00000200
> > ...
> 
> This would be nice to have in include/asm-generic. Please make a patch that
> adds the file there and use it with your scripts.
Ok, my pleasure.

> 
> > --- /dev/null
> > +++ b/arch/unicore32/include/asm/stat.h
> > @@ -0,0 +1,71 @@
> > +/*
> > + * linux/arch/unicore32/include/asm/stat.h
> 
> I think we discussed this particular header before. There should be no reason
> to have your own version instead of using the generic file like you do for the
> rest of the API headers.
The generic-version stat.h can't work for existing binary file systems in unicore32.
I will submit a patch for generic-version stat.h for discussion.

> 
> 	Arnd
Thanks arnd.

Guan Xuetao

