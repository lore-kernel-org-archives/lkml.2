Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1CVNqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 09:46:39 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:59038 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab1CVNqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 09:46:37 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Stephen Boyd'" <sboyd@codeaurora.org>,
        <linux-kernel@vger.kernel.org>
References: <1300751462-1494-1-git-send-email-sboyd@codeaurora.org> <201103220934.50435.arnd@arndb.de> <20110322092113.GB17264@n2100.arm.linux.org.uk> <201103221110.20861.arnd@arndb.de>
In-Reply-To: <201103221110.20861.arnd@arndb.de>
Subject: RE: [PATCH] ARM: Use asm-generic/sizes.h
Date: Tue, 22 Mar 2011 21:43:46 +0800
Message-ID: <00ec01cbe897$2eed7210$8cc85630$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQE4tCitO1vWIib0wOPyTOUnpd6PFADDwX3XAptj/h4B/snX15U01h8A
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly, the sizes.h is do derived from arm version.
And I just complete the SZ_* definitions for 32-bit architecture,
and remove SZ_48M for not being power-of-2 size.
I am sorry for removing copyright information when cleaning-up the code.
However, the content of this file is so common sense for handy sizes.
So, I believe that GPLv2 license is enough.

Regards.

Guan Xuetao

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Tuesday, March 22, 2011 6:10 PM
> To: linux-arm-kernel@lists.infradead.org; Guan Xuetao
> Cc: Russell King - ARM Linux; Stephen Boyd; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] ARM: Use asm-generic/sizes.h
> 
> On Tuesday 22 March 2011, Russell King - ARM Linux wrote:
> > On Tue, Mar 22, 2011 at 09:34:50AM +0100, Arnd Bergmann wrote:
> > > On Tuesday 22 March 2011, Stephen Boyd wrote:
> > > > Commit d232b12 (asm-generic headers: add sizes.h, 2011-01-15)
> > > > introduced a generic sizes.h. Use that instead of the ARM specific
> > > > version.
> > > >
> > > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > >
> > > Acked-by: Arnd Bergmann <arnd@arndb.de
> >
> > I assume the generic version was derived from the ARM version.  Is there
> > a reason why ARM Ltd's copyright was seemingly dropped?
> 
> I'll let Guan Xuetao answer that, he introduced the file along with the
> unicore32 architecture.
> 
> I doubt that the contents of this file are copyrightable, but of course
> that is normally no reason to remove the notice.
> 
> 	Arnd

