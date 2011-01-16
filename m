Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1APPgL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 10:36:11 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:47674 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab1APPgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 10:36:08 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: <sfr@canb.auug.org.au>, "'Arnd Bergmann'" <arnd@arndb.de>,
        <gregkh@suse.de>, <jbarnes@virtuousgeek.org>, <rubini@cvml.unipv.it>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-next@vger.kernel.org>
References: <004901cbb4d5$b9bb1370$2d313a50$@mprc.pku.edu.cn> <20110115220809.GC19872@core.coreip.homeip.net>
In-Reply-To: <20110115220809.GC19872@core.coreip.homeip.net>
Subject: RE: Request for unicore32 architecture codes to merge into linux-next
Date: Sun, 16 Jan 2011 23:35:29 +0800
Message-ID: <005901cbb593$04c7e420$0e57ac60$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQKvmpDs5qji3UzzcGj9LCTNHzRliwKk9OIdkfbGhZA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Sunday, January 16, 2011 6:08 AM
> To: Guan Xuetao
> Cc: sfr@canb.auug.org.au; Arnd Bergmann; gregkh@suse.de; jbarnes@virtuousgeek.org; rubini@cvml.unipv.it; linux-
> arch@vger.kernel.org; linux-kernel@vger.kernel.org; linux-fbdev@vger.kernel.org; linux-next@vger.kernel.org
> Subject: Re: Request for unicore32 architecture codes to merge into linux-next
> 
> Hi,
> 
> On Sun, Jan 16, 2011 at 01:00:31AM +0800, Guan Xuetao wrote:
> > Hi,
> >
> > I want to merge unicore32 repo into linux-next tree, the position is (unicore32 branch):
> >   git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git
> >
> 
> Have these changes been reviewed at all? Looking at the input parts I
> doubt it... We try _really_ hard to avoid sprinkling arch #ifedefs in
> the common code.
Many people helped me to review the patchset in linux-arch and linux-kernel mailist.
For ps2 driver, perhaps I should not introduce bugfix for the machine, so I remove the additional
modification, and only i8042 is necessary.
The patchset is rebased, and git dir and branch name remain the same.
Please update.
> 
> So, for input:
> 
> - how big is the difference between standard keytable and the one you
>   are introducing? Looks like you are just adding 5 new keys that are
>   not critical for booting. So please just update keymap from userpsace
>   as we do for countless laptops and keyboards out there.
I understand.
And I remove the keytable.

> 
> - Trying to enable mouse 1000 times can lead to loooong delays. Have
>   you tried to figure out why you need the loop?
> 
> - What kind of mice can be connected to teh devices? I am concerned that
>   your super-strict protocol checks will cause more harm then good (i do
>   not believe they are valied in general case, overflow is just and
>   additional bit).
> 
> Please split changes related into logically separated patches and post
> them on linux-input@vger.kernel.org (along with linux-kernel if you
> prefer) for review and comments.
> 
> Thanks.
> 
> --
> Dmitry

Thanks Dmitry.

Guan Xuetao

