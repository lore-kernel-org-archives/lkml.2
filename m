Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab2KZLiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:38:10 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:31229 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab2KZLiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:38:08 -0500
X-AuditID: cbfee61b-b7f616d00000319b-03-50b3549df64d
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1353929860.26584.63.camel@kjgkr>
Subject: Re: [RESEND] Request f2fs filesystem inclusion in linux-next
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Date: Mon, 26 Nov 2012 20:37:40 +0900
In-reply-to: <20121126101839.cdea3cebc6534722072e3fd0@canb.auug.org.au>
References: <1353734925.26584.43.camel@kjgkr>
 <20121126101839.cdea3cebc6534722072e3fd0@canb.auug.org.au>
Organization: samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zI915IZsDDF6s57bYs/cki8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mo4e+UeU8EpmYr9axazNzDuEe5i5OSQEDCRWP//DzuE
	LSZx4d56ti5GLg4hgWWMEv+n9jB1MXKAFV3/pgYRn84o8W/DNxaQBl4BQYkfk++B2cwC6hKT
	5i1ihrBFJBbN6WaFsLUlli18zQzR/JpR4uiJZVDNuhIfXk0As4UFXCV2PtnNBrKMDahh834D
	kLCQgKLE2/13WUHCIkDhA78FQMYwCzxklJhz8wTY0SwCqhJP2rrZQGxOAXeJ0w8PMkL0Zkms
	WLobbDy/gKjEydZPjBBPKknsbu+E6hWQ+Db5EAvEj7ISmw6AnSkhsI5d4u7ap8wQ9ZISB1fc
	YJnAKDkLycuzkLw8C8nLs5C8vICRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGSOxJ72Bc
	1WBxiFGAg1GJh1fy2KYAIdbEsuLK3EOMEhzMSiK8Z703BwjxpiRWVqUW5ccXleakFh9i9AG6
	fCKzlGhyPjAt5JXEGxobm5iZmJqYW5qam+IQVhLnbfZICRASSE8sSc1OTS1ILYIZx8TBKdXA
	KPyv53BkgpWOpLfoj1nBKpwrUoMr2yrYTDyfPXoZuuHc2sy963bUKc3h1DWpTnjreXqmtt5q
	nr2B/9MXen2zdfjyQLH56Auby2dOKk6vOHF4hteE7+yTpv08/EKE12hNZ82nuCsHT008YqQm
	vWlyOrt1gWR05el7qXNv9n67ckW9w9Py/BfBQ0osxRmJhlrMRcWJAPofZEDqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jQd25IZsDDF71mVvs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmXLq+nqngkEzF
	w9eL2BoYtwh3MXJwSAiYSFz/ptbFyAlkiklcuLeerYuRi0NIYDqjxL8N31hAErwCghI/Jt9j
	AalnFpCXOHIpGyTMLKAuMWneImaI+teMEkdPLIOq15X48GoCmC0s4Cqx88luNpBeNgFtic37
	DUDCQgKKEm/332UFCYsAhQ/8FgAZwyzwkFFizs0T7CA1LAKqEk/autlAbE4Bd4nTDw8yQvRm
	SaxYuhtsPL+AqMTJ1k+MEPcrSexu72SfwCg0C8nVsxCunoXk6gWMzKsYRVMLkguKk9JzjfSK
	E3OLS/PS9ZLzczcxgqP0mfQOxlUNFocYBTgYlXh4JY9tChBiTSwrrsw9xCjBwawkwnvWe3OA
	EG9KYmVValF+fFFpTmrxIUYfoMMnMkuJJucDE0heSbyhsYmZkaWRmYWRibk5DmElcd5mj5QA
	IYH0xJLU7NTUgtQimHFMHJxSDYxNJyad3/lv3rT2+EZV9ZvP5UzjM7N+OVr07nU2Cc2c4Daj
	qO5s6LJXsasTVop5XpptdmVDn23AjYkhUv/yVO8/lAnatdTIvNnRYqKGRc017QObrePEbN41
	6CbEHY55M7Fhpp3n7iOzq7e2JuWosv60yfbc0tvMe+rskYXPr/gf3Nj5/eriHWeVWIozEg21
	mIuKEwEZN3CN/wIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-11-26 (월), 10:18 +1100, Stephen Rothwell:
> Hi,
> 
> On Sat, 24 Nov 2012 14:28:45 +0900 Jaegeuk Kim <jaegeuk.kim@samsung.com> wrote:
> >
> > About two month ago, I submitted a new file system, namely
> > flash-friendly file system (f2fs) to LKML.
> >  http://en.wikipedia.org/wiki/F2FS
> >  http://lkml.org/lkml/2012/10/5/205
> >  http://lwn.net/Articles/518718/
> > 
> > In the mean time, many folks have pointed out several essential issues
> > on f2fs, and now I think most of them have been resolved moderately.
> > 
> > So, I'd like to request a new branch being included in linux-next for
> > the purpose of merging into the next mainline kernel.
> 
> I have no problem adding this to linux-next (and noone has screamed aver
> the past few days, so that is a good sign) except that the branch you
> have submitted is actually based on linux-next itself.  You cannot base
> anything on linux-next as it rebases every day.  You need to base your
> tree in Linus' tree (or some other *stable* tree).
> 

I've done making a correct tree.
Could you please merge the following f2fs patches?

1. tree
git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git

2. branch
dev

3. Contact
Jaegeuk Kim <jaegeuk.kim@samsung.com>

4. Short log

Greg Kroah-Hartman (1):
  f2fs: move proc files to debugfs

Jaegeuk Kim (16):
  f2fs: add document
  f2fs: add on-disk layout
  f2fs: add superblock and major in-memory structure
  f2fs: add super block operations
  f2fs: add checkpoint operations
  f2fs: add node operations
  f2fs: add segment operations
  f2fs: add file operations
  f2fs: add address space operations for data
  f2fs: add core inode operations
  f2fs: add inode operations for special inodes
  f2fs: add core directory operations
  f2fs: add xattr and acl functionalities
  f2fs: add garbage collection functions
  f2fs: add recovery routines for roll-forward
  f2fs: update Kconfig and Makefile

 Documentation/filesystems/00-INDEX |    2 + 
 Documentation/filesystems/f2fs.txt |  417 +++++++++
 fs/Kconfig                         |    1 + 
 fs/Makefile                        |    1 + 
 fs/f2fs/Kconfig                    |   52 ++
 fs/f2fs/Makefile                   |    7 + 
 fs/f2fs/acl.c                      |  465 ++++++++++
 fs/f2fs/acl.h                      |   57 ++
 fs/f2fs/checkpoint.c               |  792 ++++++++++++++++
 fs/f2fs/data.c                     |  701 ++++++++++++++
 fs/f2fs/debug.c                    |  361 ++++++++
 fs/f2fs/dir.c                      |  672 ++++++++++++++
 fs/f2fs/f2fs.h                     | 1062 +++++++++++++++++++++
 fs/f2fs/file.c                     |  637 +++++++++++++
 fs/f2fs/gc.c                       |  742 +++++++++++++++
 fs/f2fs/gc.h                       |  117 +++
 fs/f2fs/hash.c                     |   98 ++
 fs/f2fs/inode.c                    |  266 ++++++
 fs/f2fs/namei.c                    |  504 ++++++++++
 fs/f2fs/node.c                     | 1763
+++++++++++++++++++++++++++++++++++
 fs/f2fs/node.h                     |  353 +++++++
 fs/f2fs/recovery.c                 |  375 ++++++++
 fs/f2fs/segment.c                  | 1798
++++++++++++++++++++++++++++++++++++
 fs/f2fs/segment.h                  |  615 ++++++++++++
 fs/f2fs/super.c                    |  656 +++++++++++++
 fs/f2fs/xattr.c                    |  389 ++++++++
 fs/f2fs/xattr.h                    |  145 +++
 include/linux/f2fs_fs.h            |  410 ++++++++
 include/uapi/linux/magic.h         |    1 +
 29 files changed, 13459 insertions(+)



-- 
Jaegeuk Kim
Samsung

