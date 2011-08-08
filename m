Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab1HHRcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:32:41 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39244 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab1HHRck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:32:40 -0400
Date: Mon, 8 Aug 2011 13:25:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: b43: LCN-PHY add place for new PHY support
Message-ID: <20110808172546.GC21103@tuxdriver.com>
References: <201107230012.p6N0CZSM002466@hera.kernel.org>
 <CAMuHMdU0Cba9xFjfD6Fq1MqE5xZeDnsdN8qipmR6jQH9J6X4vQ@mail.gmail.com>
 <CACna6ryx4k5fFmqbDPZ3pdDA_SbjZQQVaJNQyALkx0i8+S-7hA@mail.gmail.com>
 <CA+XFjioJPCvp+=-3Eg06bzHuXGbFCUoyGguhTL5DqqcpqN0ZXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+XFjioJPCvp+=-3Eg06bzHuXGbFCUoyGguhTL5DqqcpqN0ZXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 06:07:07PM +0200, Gábor Stefanik wrote:
> 2011/8/8 Rafał Miłecki <zajec5@gmail.com>:
> > W dniu 8 sierpnia 2011 13:57 użytkownik Geert Uytterhoeven
> > <geert@linux-m68k.org> napisał:
> >> On Sat, Jul 23, 2011 at 02:12, Linux Kernel Mailing List
> >> <linux-kernel@vger.kernel.org> wrote:
> >>> Gitweb:     http://git.kernel.org/linus/1d738e64f3d957d56c1b51e64ebdef986a8760e3
> >>> Commit:     1d738e64f3d957d56c1b51e64ebdef986a8760e3
> >>> Parent:     0cd20a278e1ef9da9f6a987942794c9d65af8c4d
> >>> Author:     Rafał Miłecki <zajec5@gmail.com>
> >>> AuthorDate: Thu Jul 7 15:25:27 2011 +0200
> >>> Committer:  John W. Linville <linville@tuxdriver.com>
> >>> CommitDate: Fri Jul 8 11:11:25 2011 -0400
> >>
> >>> diff --git a/drivers/net/wireless/b43/phy_lcn.h b/drivers/net/wireless/b43/phy_lcn.h
> >>> new file mode 100644
> >>> index 0000000..c046c2a
> >>> --- /dev/null
> >>> +++ b/drivers/net/wireless/b43/phy_lcn.h
> >>
> >>> \ No newline at end of file
> >>
> >> Woops...
> >>
> >> gcc/cpp also complains:
> >>
> >> drivers/net/wireless/b43/phy_lcn.h:14:28: warning: no newline at end of file
> >
> > Sorry, I didn't know we want empty lines at the end. I also don't
> > think it's mentioned in kernel's CodingStyle.
> 
> I'm pretty sure it is basic Unix knowledge that all text files SHOULD
> (RFC 2119) end with a newline character, unless otherwise noted
> explicitly. In fact, many Unix text editors automatically insert a
> newline at the end, and forbid you from deleting it.

Please use an editor that does this appropriately, but do _not_
simply add an empty line at the end of a file.  'git am' complains
about empty lines at the end of a file during a commit.

I find that simple loading and saving such files with vi is sufficient
for me -- YMMV.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
