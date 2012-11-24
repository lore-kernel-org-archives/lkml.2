Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab2KVTkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:40:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:32510 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223Ab2KVTkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:40:32 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ce-50adb81b2da3
Message-id: <1353734925.26584.43.camel@kjgkr>
Subject: [RESEND] Request f2fs filesystem inclusion in linux-next
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: sfr@canb.auug.org.au
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Date: Sat, 24 Nov 2012 14:28:45 +0900
Organization: samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t8zI13pHWsDDGYd57TYs/cki8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MpoPnSXsWCyRMW8aRoNjF0CXYycHBICJhLrZn5igbDF
	JC7cW8/WxcjFISSwjFFi7b8nLHBF9xcyQySmM0p07djNBOG8ZpR4+GkmM0gVr4CuRPe0U6wg
	trCAo8S9rp1AcQ4ONgFtic37DUDCQgKKEm/33wUrERGQkJjb1cwIModZ4CGjxJybJ9hBEiwC
	qhI3t+5nArH5BUQlTrZ+YgSxmQXUJSbNW8QMcZGSxO72TnaIuLzE5jVvoW4QlPgx+R4LxBwB
	iW+TD7GA3CAhICux6QDYAxIC3ewSF48cYoeYIylxcMUNlgmMYrOQrJiFZOwsJGMXMDKvYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAiJDukdjKsaLA4xCnAwKvHwZhisDRBiTSwrrsw9xCjB
	wawkwruoACjEm5JYWZValB9fVJqTWnyI0Qfo2onMUqLJ+cDIzSuJNzQ2NjEzMTUxtzQ1N8Uh
	rCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qB0anwhENDTnGki1P9/IKfotH3pk30nut/dreD
	YPNLm3krfwQW6nLLvOpbrLAoTU4+Q4N7waeV2nuaHs9SKTWrjHDgebH9k/RrFhuDT5ueJUsv
	iLg8d+Uc999ivCfaDJ9XNJXNMXzK76mz6rAx067JDeEHw9enN9VviHBn/xSe2B09XbNRzYFf
	iaU4I9FQi7moOBEAZ52mNrsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t9jQV3pHWsDDHb3M1vs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmNB+6y1gwWaJi
	3jSNBsYugS5GTg4JAROJdfcXMkPYYhIX7q1n62Lk4hASmM4o0bVjNxOE85pR4uGnmWBVvAK6
	Et3TTrGC2MICjhL3unYCxTk42AS0JTbvNwAJCwkoSrzdfxesRERAQmJuVzMjyBxmgYeMEnNu
	nmAHSbAIqErc3LqfCcTmFxCVONn6iRHEZhZQl5g0bxHURUoSu9s72SHi8hKb17yFukFQ4sfk
	eywTGAVmIWmZhaRsFpKyBYzMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCY++Z9A7GVQ0W
	hxgFOBiVeHgzDNYGCLEmlhVX5h5ilOBgVhLhXVQAFOJNSaysSi3Kjy8qzUktPsToA/TFRGYp
	0eR8YFrIK4k3NDYxM7I0MrMwMjE3xyGsJM7b7JESICSQnliSmp2aWpBaBDOOiYNTqoFROfvn
	KY1c93aNl7909/11CThmts2S8fdhmRit9X+zZ8zdd+io40lrLwNDmV2lG3T1dp31n/f6Xr1Y
	jsBKbmvPej9Vfv7vTZeOetyx3z1PX/PZq/fvEmTNDWUiz+mtk/zbs3T3yom3ZtRZPlqwK1Qx
	/43l9v1PuA+YRicJ/DCZfuR5VfG8c4e0lFiKMxINtZiLihMBQ9moKeoCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

About two month ago, I submitted a new file system, namely
flash-friendly file system (f2fs) to LKML.
 http://en.wikipedia.org/wiki/F2FS
 http://lkml.org/lkml/2012/10/5/205
 http://lwn.net/Articles/518718/

In the mean time, many folks have pointed out several essential issues
on f2fs, and now I think most of them have been resolved moderately.

So, I'd like to request a new branch being included in linux-next for
the purpose of merging into the next mainline kernel.

The info for linux-next:

1. tree
git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/linux-next-f2fs.git

2. branch
f2fs

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

Any review comments welcome.
Thank you.

-- 
Jaegeuk Kim
Samsung


