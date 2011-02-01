Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab1BAFPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 00:15:50 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:37430 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab1BAFPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 00:15:49 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: <sfr@canb.auug.org.au>, "'Andrew Morton'" <akpm@linux-foundation.org>,
        "Arnd Bergmann" <arnd@arndb.de>, <gregkh@suse.de>,
        <linux-kernel@vger.kernel.org>
References: <AANLkTimKUV=RQezzME9qUUQjUjnHt9Qe79hOpK-cFC3i@mail.gmail.com> <20110201093852.32c951b6.sfr@canb.auug.org.au>
In-Reply-To: <20110201093852.32c951b6.sfr@canb.auug.org.au>
Subject: FW: Request (2nd) for unicore32 architecture codes to merge into linux-next
Date: Tue, 1 Feb 2011 13:14:56 +0800
Message-ID: <016001cbc1ce$f83b7120$e8b25360$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIVfHgUb1V/E3RAdxK8gz2tBQHXgQIENA7Vk0iApVA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus:
  Due to helps from many kindly peoples, unicore32 branch could be a candidate to merge into linux kernel.
  The position is (unicore32 branch):
    git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git 
  which had been integration tested from linux-next-20110131.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Guan Xuetao

> -----Original Message-----
> From: linux-next-owner@vger.kernel.org [mailto:linux-next-owner@vger.kernel.org] On Behalf Of Stephen Rothwell
> Sent: Tuesday, February 01, 2011 6:39 AM
> To: Xuetao Guan
> Cc: dmitry.torokhov@gmail.com; arnd@arndb.de; gregkh@suse.de; dtor@mail.ru; jbarnes@virtuousgeek.org; linux-
> next@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: Request (2nd) for unicore32 architecture codes to merge into linux-next
> 
> Hi,
> 
> On Sat, 22 Jan 2011 21:52:11 +0800 Xuetao Guan <epip.guan@gmail.com> wrote:
> >
> > I want to merge unicore32 repo into linux-next tree, the position is
> > (unicore32 branch):
> >   git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git
> 
> Included from next-20110131.
> 
> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgment of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window.
> 
> You will need to ensure that the patches/commits in your tree/series have
> been:
>      * submitted under GPL v2 (or later) and include the Contributor's
> 	Signed-off-by,
>      * posted to the relevant mailing list,
>      * reviewed by you (or another maintainer of your subsystem tree),
>      * successfully unit tested, and
>      * destined for the current or next Linux merge window.
> 
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.
> 
> --
> Cheers,
> Stephen Rothwell
> sfr@canb.auug.org.au
> 
> Legal Stuff:
> By participating in linux-next, your subsystem tree contributions are
> public and will be included in the linux-next trees.  You may be sent
> e-mail messages indicating errors or other issues when the
> patches/commits from your subsystem tree are merged and tested in
> linux-next.  These messages may also be cross-posted to the linux-next
> mailing list, the linux-kernel mailing list, etc.  The linux-next tree
> project and IBM (my employer) make no warranties regarding the linux-next
> project, the testing procedures, the results, the e-mails, etc.  If you
> don't agree to these ground rules, let me know and I'll remove your tree
> from participation in linux-next.

