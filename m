Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab2K0HVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:21:15 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:44613 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140Ab2K0HVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:21:14 -0500
X-AuditID: cbfee61b-b7f616d00000319b-e4-50b469e8ea06
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@gmail.com,
        cw00.choi@samsung.com, kyungmin.park@samsung.com,
        sachin.kamat@linaro.org, khoroshilov@ispras.ru
Subject: Re: Re: Re: [GIT PULL] extcon for Linux 3.8
Date: Tue, 27 Nov 2012 16:21:09 +0900
Message-id: <1354000869-26589-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-reply-to: <20121127042631.GA17479@kroah.com>
References: <20121127042631.GA17479@kroah.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t8zbd0XmVsCDCZOErG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZhw49ZCp4LV9xsX8aSwPjHqkuRk4OCQETiR9Nq9ghbDGJC/fW
	s3UxcnEICSxjlNiydRczTNGb31uhEtMZJc5PaGSCcJYySbw+e5gRpIpNQFdi64a7LCC2iICc
	xJPbf5hBipgF5jFKTHl0DmyHMNCoW7dPM4HYLAKqEm8a5oLZvAIeEncW/GCEWKcg8evIKlYQ
	m1NAX+Lc1WNsILaQgJ5Ez7OFjBC9AhLfJh8CWsYBVC8rsekA2C4JgetsEm/nLGSFmCMpcXDF
	DZYJjMILGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYoSEofQOxlUNFocYBTgYlXh4Mxdt
	DhBiTSwrrsw9xCjBwawkwrtYZ0uAEG9KYmVValF+fFFpTmrxIUYfoEsmMkuJJucDYySvJN7Q
	2MDY0NDS0MzU0tQAh7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsaIMJtVHx6LXrqQ0dXv
	ycHgGPuB0TKUUYwvQKI3vePyoZ6WDpFvL2Y+2+uvturb1yVSb5fsvL65wS1l4nzbjV1RF2Zy
	TWB7tuDTtqCap65zX6i6O9fErRdyj/3JFpdix5WRMunH3z8zZv4rvFvmuPlE9L9E2w9Hfh5c
	aKm15+Kr15cXLjsrxhugxFKckWioxVxUnAgARc8Dg3ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+xoO6LzC0BBt/v81hc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjEOHHjIVvJavuNg/jaWB
	cY9UFyMnh4SAicSb31vZIGwxiQv31gPZXBxCAtMZJc5PaGSCcJYySbw+e5gRpIpNQFdi64a7
	LCC2iICcxJPbf5hBipgF5jFKTHl0jh0kIQw09tbt00wgNouAqsSbhrlgNq+Ah8SdBT8YIdYp
	SPw6sooVxOYU0Jc4d/UY2BlCAnoSPc8WMk5g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85
	P3cTIzjIn0nvYFzVYHGIUYCDUYmHN3PR5gAh1sSy4srcQ4wSHMxKIryLdbYECPGmJFZWpRbl
	xxeV5qQWH2L0AbpqIrOUaHI+MALzSuINjU3MjCyNzIxNzI2NcQgrifM2e6QECAmkJ5akZqem
	FqQWwYxj4uCUamCsfXD18mzj+KWSabdfsnQuMf4pqh86c65X06z4S22lPt6XXruvn5fhzazw
	9uaiyLyIA4+DJihdnrj7lbJKfeDUx89s999blWjQxNejsCNkRhpHis3hojNzQxisvjGWT3y4
	ce3GG1XuWleUZjg0CzeuvFsz5734EqvCLmfTpBSdlLgd9rOUbmxQYinOSDTUYi4qTgQAGqvc
	hJ8CAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

> On Tue, Nov 27, 2012 at 12:54:30AM +0000, MyungJoo Ham wrote:
> > > On Thu, Nov 22, 2012 at 01:51:10PM +0900, MyungJoo Ham wrote:
> > > > Please pull extcon patches for Linux 3.8.
> > > 
> > > This is not a signed-tag pull request, which I thought I asked for
> > > previously.
> > > 
> > > Please create that, so that I can properly know I am getting the right
> > > pull request and patches.
> > 
> > A singed tag, "pull_req_20121122", has been already attached at the HEAD
> > of for-next branch.
> > 
> > Would it be more readable if the request is made with
> > git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon.git tags/pull_req_20121122
> > rather than
> > git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon.git for-next
> > ? (both point to the same commit and I tried the first URL for git request-pull; however git request-pull gives me the second URL as the result)
> 
> git request-pull should show you the proper tag, if you are using a new
> version of git (i.e. something fairly recent.)  What version of git are
> you using?  How did you create the signed tag?
> 
> thanks,
> 
> greg k-h

I'm using 1.7.5.4. 

And are you talking about the git update of
"682853e68 request-pull: really favor a matching tag"?

The process I did for creating request-pull message was:

$ git tag -U D606808A pull_req_20121122 HEAD
$ git push --tags
$ git request-pull f4a75d2eb7b1e2206094b901be09adb31ba63681 git:/git.kernel.org:/pub/scm/linux/kernel/git/mzx/extcon tags/pull_req_20121122 HEAD

Anyway, with the version 1.7.9.5, it produces messages with proper tag ids.


The following changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:

  Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon tags/pull_req_20121122

----------------------------------------------------------------
extcon pull request targetting Linux 3.8 for Greg KH on 2012.11.22
This is based on Linux 3.7 rc6

----------------------------------------------------------------
Alexey Khoroshilov (1):
      extcon: arizona: unlock mutex on error path in arizona_micdet()

Chanwoo Choi (1):
      extcon: Add missing header file to extcon.h

MyungJoo Ham (1):
      extcon: kernel_doc style fix

Sachin Kamat (9):
      extcon: Fix return value in extcon-class.c
      extcon: max8997: Fix incorrect error check and return value
      extcon: max77693: Fix incorrect error check and return value
      extcon: max77693: Fix coding style
      extcon: max8997: Fix checkpatch error
      extcon: max8997: Fix a typo
      extcon: max8997: Use devm_kzalloc
      extcon: max77693: Use devm_kzalloc
      extcon: max77693: Fix uninitialised variable warning

 drivers/extcon/extcon-arizona.c  |    1 +
 drivers/extcon/extcon-class.c    |    2 +-
 drivers/extcon/extcon-max77693.c |   36 ++++++++++++---------------
 drivers/extcon/extcon-max8997.c  |   28 +++++++++------------
 include/linux/extcon.h           |   50 +++++++++++++++++++------------------
 5 files changed, 56 insertions(+), 61 deletions(-)


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQtGkcAAoJEBOhurvWBoCK2EAP/1Hp3nKFCaNbqy7e1yg+bovM
aSDSr+0XajZOuF+Cx8yE+2DtaRBEwu7vXyzMOek9daxGBAiLOHu+FyDTa5D67p8J
eO031IHkg+Lx6JHip3csRQoyflTDc1pKnAMEKBPBPbVIqErw4q+d0WWfbQQ70z0g
Pb3iM+pLb5sIvgbdJBMRsZ1JQFgHj1Fy558s9uaCQtlh2fw6zRuj5yi8nMAzxU8c
DfSa0I2ESYeDfj+n5EoUdF3LmGeeSsrgWX4v9EtDCmzCGroddLA8BlmeTXhr32oI
9Kb7VmsUnUDtizQ59WYyiyku3NMa64LPdfqy3wlAJYbQxPJrg2AOlFzwOIbL1uLj
0ix5iq9k2I2bri2fHznpvbFnl/TAX8xiXGh5gfY10Vr4Z45HRFLf55usvAnwW137
I7FH/pkOd+YOBYiO0gIsj5ay7vpHLk9ezE9oXpUe2k9bSYXR3SAfd1cjNeAVQE1g
4nq68c6Mk3kU5COyUfoUIu8k62BnyKsWYzsI6bEfBzN1sfB3Q4fxGP+FVaAEYv80
1VwdiNeUKiDE7RTq5aBr9mXJFwoHwoZ4iuSyaQewyyZEveia9SSpp1KgvSZTAIc/
8ibW/oVYbz+US0CHzCllLBApjNrDKy/vywFfY4R5R/oxbospKICdogu/hZwbcHw3
1WF9ehMD7PW4HIrcM2hT
=ytmK
-----END PGP SIGNATURE-----
