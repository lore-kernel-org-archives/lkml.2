Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab1JLMap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:30:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53046 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab1JLMam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:30:42 -0400
From: "Premi, Sanjeev" <premi@ti.com>
To: Michal Marek <mmarek@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 Oct 2011 18:00:18 +0530
Subject: RE: [PATCH] kconfig: fix warnings due to unused return values
Thread-Topic: [PATCH] kconfig: fix warnings due to unused return values
Thread-Index: AcyDcIZPRnsw6Z0USCa0BpE3qM2cWwBYGyHQAQI+LRA=
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930257A57806@dbde02.ent.ti.com>
References: <1316691396-25447-1-git-send-email-premi@ti.com>
 <4E8C72B6.9030603@suse.cz>
 <B85A65D85D7EB246BE421B3FB0FBB59302579AD86F@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59302579AD86F@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
> Premi, Sanjeev
> Sent: Friday, October 07, 2011 2:49 PM
> To: Michal Marek
> Cc: linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] kconfig: fix warnings due to unused return values
> 
> > -----Original Message-----
> > From: Michal Marek [mailto:mmarek@suse.cz] 
> > Sent: Wednesday, October 05, 2011 8:38 PM
> > To: Premi, Sanjeev
> > Cc: linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] kconfig: fix warnings due to unused 
> return values
> > 
> > On 22.9.2011 13:36, Sanjeev Premi wrote:
> > > The return value of wattrset() is being ignored in the
> > > code and newer compilers complain about this e.g.
> > > 
> > > HOSTCC  scripts/kconfig/lxdialog/checklist.o
> > > scripts/kconfig/lxdialog/checklist.c: In function print_item:
> > > scripts/kconfig/lxdialog/checklist.c:40: warning: value 
> > computed is not used
> > > scripts/kconfig/lxdialog/checklist.c:46: warning: value 
> > computed is not used
> > > 
> > > Let the compiler know that ignore is intentional.
> > > 
> > > Signed-off-by: Sanjeev Premi <premi@ti.com>
> > > ---
> > > 
> > >   The patch was created against the last pull from git.kernel.org
> > >   The 'pull' from github is taking more than few hours...
> > > 
> > >   Based on the time stamps at this url, I believe the patch should
> > >   apply cleanly:
> > >    
> > 
> https://github.com/torvalds/linux/tree/master/scripts/kconfig/lxdialog
> > 
> > The latest kconfig tree is at http://repo.or.cz/w/linux-kbuild.git,
> > branch kconfig. You can pull it by
> > 
> > $ git fetch git://repo.or.cz/linux-kbuild.git kconfig:kconfig
> 
> Sure, I will pull it.

I tried the menuconfig after pulling from this repo and still see the
same warnings.

For reference, the HEAD is at:
  commit 93072c3ecafcf188390750cc755185f3150736b9
  scripts/kconfig/nconf: add KEY_HOME / KEY_END for dialog_inputbox

[snip]...[snip]

> 
> I am on Ubuntu 10.04.1 LTS
> 
> premi #
> premi # gcc --version
> gcc (Ubuntu 4.4.3-4ubuntu5) 4.4.3
> Copyright (C) 2009 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions. 
>  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A 
> PARTICULAR PURPOSE.
> premi #
> premi #
> premi # dpkg --get-selections | grep curses
> lib32ncurses5                                   install
> libcurses-perl                                  install
> libcurses-ui-perl                               install
> libncurses5                                     install
> libncurses5-dev                                 install
> libncursesw5                                    install
> ncurses-base                                    install
> ncurses-bin                                     install
> premi #

This information is in my previous mail, but keeping here just
for easy reference.

~sanjeev

[snip]...[snip]

