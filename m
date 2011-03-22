Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab1CVMdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:33:08 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:41095 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab1CVMdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:33:06 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>, "'Chris Metcalf'" <cmetcalf@tilera.com>
Cc: <linux-kernel@vger.kernel.org>, "'Chen Liqin'" <liqin.chen@sunplusct.com>,
        "'Lennox Wu'" <lennox.wu@gmail.com>
References: <201103191554.p2JFsQ9N010993@farm-0023.internal.tilera.com> <201103192147.20632.arnd@arndb.de>
In-Reply-To: <201103192147.20632.arnd@arndb.de>
Subject: RE: [PATCH] asm-generic: support clock_adjtime() in <asm-generic/unistd.h>
Date: Tue, 22 Mar 2011 20:32:10 +0800
Message-ID: <00d801cbe88d$2bcdc710$83695530$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFfWvWMWHyCyW2gLNbq//trOQUMbgG/HY7IlQRrJ7A=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Sunday, March 20, 2011 4:47 AM
> To: Chris Metcalf
> Cc: linux-kernel@vger.kernel.org; Guan Xuetao; Chen Liqin; Lennox Wu
> Subject: Re: [PATCH] asm-generic: support clock_adjtime() in <asm-generic/unistd.h>
> 
> On Saturday 19 March 2011 16:47:53 Chris Metcalf wrote:
> >
> > A syscall was added without being added to asm-generic, which
> > makes tile (and presumably score and unicore32) break.
> >
> > Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> > Cc: Chen Liqin <liqin.chen@sunplusct.com>
> > Cc: Lennox Wu <lennox.wu@gmail.com>
> 
> I don't consider it actually broken, but your patch
> is definitely needed to support the new syscall, and
> looks totally correct.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> I don't have any other changes queued up for asm-generic
> in this release, so please just merge it through your
> tree if you like.
> 
> 	Arnd

Looks good. At least it will remove the warning for unimplemented syscall.

Thanks & Regards.

Guan Xuetao

