Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934149Ab2JWXSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:18:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57024 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933778Ab2JWXSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:18:38 -0400
X-AuditID: cbfee61b-b7f616d00000319b-0d-508725cc7ac0
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Greg KH'" <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <20121023182659.GA6587@kroah.com> <20121023185753.GA2466@kroah.com>
In-reply-to: <20121023185753.GA2466@kroah.com>
Subject: RE: [PATCH 00/16 v2] f2fs: introduce flash-friendly file system
Date: Wed, 24 Oct 2012 08:18:36 +0900
Message-id: <013801cdb174$ba5ca990$2f15fcb0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2xUE/sM9Gf2OOKQSO1RjoyYl6e2gAI+JHw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zY90zqu0BBjc/Glns2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWsPjOHpeAXe8XHR7NZGhj72boYOTkkBEwkzl3/zAxh
	i0lcuLceKM7FISSwjFFi86Nj7DBFD+a2skIkpjNKvFn8kwkkISTwj1Gi/V9mFyMHB5uAtsTm
	/QYgYREBLYlnx3Ywg9QzCxxmlPj0aDELRHMzo8SS/VcZQao4BfQkfs2dCmYLC3hIrH23EMxm
	EVCVuLZgK9hJvAK2Eht2v2KCsAUlfky+xwKyjBmo9/5FLZAws4C8xOY1b5lBwhIC6hKP/upC
	3GAksWTadmaIEhGJfS/eQU0XkPg2+RALRLmsxKYDYGdKCKxjl9h8ZBkrxL+SEgdX3GCZwCgx
	C8niWQiLZyFZPAvJhgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxQiJMegfjqgaLQ4wC
	HIxKPLyJJ9oChFgTy4orcw8xSnAwK4nwTr4LFOJNSaysSi3Kjy8qzUktPsToA3T4RGYp0eR8
	YPTnlcQbGhubmJmYmphbmpqb4hBWEudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cCYwvrCRUTw
	Y8F15R13rsQq80w8NmXR66MTFV8myewKXb3E5vTbx/7SvoFLohhjp7JkeN6dJax/i1tTUEu/
	1vjTEZWas/emWZ4I7Gq5LqfpfKxA60fRJfHHLKLtR/lbf9ZcjPvA67RlppCCklPjjC260m9/
	bPi7qnPSjSjml5ELH8xlv7zsBNNHJZbijERDLeai4kQADYSpo90CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQd0zqu0BBhPX61vs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmrD4zh6XgF3vF
	x0ezWRoY+9m6GDk5JARMJB7MbWWFsMUkLtxbDxTn4hASmM4o8WbxTyaQhJDAP0aJ9n+ZXYwc
	HGwC2hKb9xuAhEUEtCSeHdvBDFLPLHCYUeLTo8UsEM3NjBJL9l9lBKniFNCT+DV3KpgtLOAh
	sfbdQjCbRUBV4tqCrcwgNq+ArcSG3a+YIGxBiR+T77GALGMG6r1/UQskzCwgL7F5zVtmkLCE
	gLrEo7+6EDcYSSyZtp0ZokREYt+Ld4wTGIVmIRk0C2HQLCSDZiHpWMDIsopRNLUguaA4KT3X
	SK84Mbe4NC9dLzk/dxMjOH6fSe9gXNVgcYhRgINRiYc38URbgBBrYllxZe4hRgkOZiUR3sl3
	gUK8KYmVValF+fFFpTmpxYcYfYDenMgsJZqcD0wteSXxhsYmZkaWRmYWRibm5jiElcR5mz1S
	AoQE0hNLUrNTUwtSi2DGMXFwSjUwqi1dOd9DyMjwYM7P1Ehl+Zua1qKO/Bv+JXp7fVVJDNVd
	vqPITfdsvJ6X/6KMt8GrD99YfFNmY9NHN9tZpy5I/j8XZWFyda7Duu2bLFbN/zbV2Ovpg0RR
	D84GRjeRJxVcpyoOtq+0X8YcZ6yqUmbkHqffJJS0NSN9t9biUnFbcwPJxO1mebpKLMUZiYZa
	zEXFiQCk0wquDAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Oct 23, 2012 at 11:26:59AM -0700, Greg KH wrote:
> > On Tue, Oct 23, 2012 at 11:21:53AM +0900, Jaegeuk Kim wrote:
> > > mkfs.f2fs
> > > =========
> > >
> > > The file system formatting tool, "mkfs.f2fs", is available from the following
> > > download page:		http://sourceforge.net/projects/f2fs-tools/
> >
> > Is there a git tree of this tool somewhere, so I don't have to
> > constantly suffer the sf.net download interface every time I want to get
> > the latest version?
> 
> Oh, and where do we report bugs for this tool?  I just formatted a usb
> stick with the mkfs.f2fs program, and it did not fully erase the old
> filesystem that was on there (iso9660), so when I mounted it, it did so
> in iso9660 mode, not f2fs mode.
> 

Any suggestion for reporting bugs?
Maybe via a mailing list?
What version did you use? (1.1.0 is correct.)
The reason we found was due to the 0'th block, so we fixed that in v1.1.0.
Thanks,

> thanks,
> 
> greg k-h


---
Jaegeuk Kim
Samsung

