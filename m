Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab1BAFFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 00:05:52 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:53530 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab1BAFFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 00:05:50 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Xuetao Guan'" <epip.guan@gmail.com>
Cc: <dmitry.torokhov@gmail.com>, <arnd@arndb.de>, <gregkh@suse.de>,
        <dtor@mail.ru>, <jbarnes@virtuousgeek.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <AANLkTimKUV=RQezzME9qUUQjUjnHt9Qe79hOpK-cFC3i@mail.gmail.com> <20110201093852.32c951b6.sfr@canb.auug.org.au>
In-Reply-To: <20110201093852.32c951b6.sfr@canb.auug.org.au>
Subject: RE: Request (2nd) for unicore32 architecture codes to merge into linux-next
Date: Tue, 1 Feb 2011 13:05:09 +0800
Message-ID: <015d01cbc1cd$9b01e440$d105acc0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIVfHgUb1V/E3RAdxK8gz2tBQHXgQIENA7Vk0iAXRA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

Thanks.

Guan Xuetao

