Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab1E0DlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 23:41:25 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:41845 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab1E0DlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 23:41:24 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <greg@kroah.com>
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn> <201105261450.01277.arnd@arndb.de>
In-Reply-To: <201105261450.01277.arnd@arndb.de>
Subject: RE: [PATCH 0/6] unicore32 subsystem: 6 patches for 2.6.39
Date: Fri, 27 May 2011 10:58:59 +0800
Message-ID: <005701cc1c1a$07d9e670$178db350$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIcsKU1gucno1VE3ekXHpcmNwpJlQLp6SS/k+eCrtA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Thursday, May 26, 2011 8:50 PM
> To: GuanXuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; greg@kroah.com
> Subject: Re: [PATCH 0/6] unicore32 subsystem: 6 patches for 2.6.39
> 
> On Thursday 26 May 2011, GuanXuetao wrote:
> > Two patches for PKUnity v3 SoC drivers:
> >         add mac driver, and move rtc driver to appropriate place
> > Two patches for new 2.6.39 updates:
> >         using generic-y and modify PERCPU macro
> > Other two patches are small fixes.
> >
> > ---
> > Guan Xuetao (6):
> >   unicore32: move rtc-puv3.c to drivers/rtc directory
> >   unicore32: add pkunity-v3 mac/net driver (umal)
> >   unicore32: change zImage physical address, though it's PIC codes
> >   unicore32: add KBUILD_DEFCONFIG with unicore32_defconfig (old
> >     debug_defconfig)
> >   unicore32: change PERCPU to PERCPU_SECTION
> >   unicore32: using generic-y format for one line asm-generic files
> >
> 
> The patches look basically ok, but two points to remember:
> 
> * The merge window is not the time to post patches for review, if you
>   want to collect Acked-by's from other people, do that in the
>   time between the merge windows, then put the patches in your git
>   tree with the Acked-by for linux-next. During the merge window, just
>   send stuff that was already in your tree to Linus.
> 
>   Bug fixes should get sent to Linus at any time, but I think you already
>   did that, all of these were either new features or cleanups.
> 
> * Add a small text explaining why you do something to each patch. The
>   one-line summary that you always have is too short for this and only
>   serves to list what you change, not why.
I see. Thanks for your explanation.

> 
> 	Arnd

Thanks & Regards.

Guan Xuetao

