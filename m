Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab2JXFel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:34:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31873 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2JXFej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:34:39 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-98-50877dededbf
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Greg KH'" <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <20121023182659.GA6587@kroah.com>
 <012e01cdb174$3068f540$913adfc0$%kim@samsung.com>
 <20121024030105.GC7982@kroah.com>
In-reply-to: <20121024030105.GC7982@kroah.com>
Subject: RE: [PATCH 00/16 v2] f2fs: introduce flash-friendly file system
Date: Wed, 24 Oct 2012 14:34:36 +0900
Message-id: <001b01cdb1a9$418a3b60$c49eb220$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2xk7zVEG/d/3BQQuWH+jqPx3+UBwAFUPDA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zQ923te0BBm2bxC327D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJentnGVjCfu2L9ddsGxk8cXYycHBICJhJ/ry9lg7DF
	JC7cWw9kc3EICSxjlLjY9JAFpujG09VMEInpjBI/191gBEkICfxjlGjaZd7FyMHBJqAtsXm/
	AUhYREBL4tmxHcwg9cwChxklPj1azAJRv5NRYtdjSZB6TgE9iQ3bmUDCwgIeEmvfLQQbySKg
	KjF/QxMriM0rYCvxfusKRghbUOLH5HtgY5iBWj/+uc0IYctLbF7zlhlkpISAusSjv7oQJxhJ
	LHs3kxWiRERi34t3UOMFJL5NPsQCUS4rsekA2JUSAqvYJR6+3cEO8a6kxMEVN1gmMErMQrJ5
	FpLNs5BsnoVkxQJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYIfEltYNxZYPFIUYBDkYl
	Ht6M820BQqyJZcWVuYcYJTiYlUR4J98FCvGmJFZWpRblxxeV5qQWH2L0Abp8IrOUaHI+MPbz
	SuINjY1NzExMTcwtTc1NcQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCUamBc1fnBOsw5O/BQ
	lLJmxRzN/FO/F/nmqgWURF/d3X19q9HNT/IqSaddg7PKt2k+Wspo+fK78vQf4ZZzZR7NWuK8
	Nnhlvyuj2Pfr6fPuVbRzfpN0NNBumm0ZtCHsx46PIs5rDl5Rd9p7XGjN/rADHlbdEb2fbT0N
	ZrBcLT9jeyv4VJ5b+GXLuHVKLMUZiYZazEXFiQC0x2Lt3AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQd23te0BBksXC1vs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmvDyzja1gPnfF
	+uu2DYyfOLoYOTkkBEwkbjxdzQRhi0lcuLeerYuRi0NIYDqjxM91NxhBEkIC/xglmnaZdzFy
	cLAJaEts3m8AEhYR0JJ4dmwHM0g9s8BhRolPjxazQNTvZJTY9VgSpJ5TQE9iw3aw+cICHhJr
	3y0EG8kioCoxf0MTK4jNK2Ar8X7rCkYIW1Dix+R7YGOYgVo//rnNCGHLS2xe85YZZKSEgLrE
	o7+6ECcYSSx7N5MVokREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5x
	Ym5xaV66XnJ+7iZGcPQ+k9rBuLLB4hCjAAejEg9vxvm2ACHWxLLiytxDjBIczEoivJPvAoV4
	UxIrq1KL8uOLSnNSiw8x+gA9OpFZSjQ5H5hY8kriDY1NzIwsjcwsjEzMzXEIK4nzNnukBAgJ
	pCeWpGanphakFsGMY+LglGpgXF19yetcrvLLuW+/+x9dH/5vkZua1mS5SS5MHwI+tvIbdumK
	ya24FSKxMvfIh4UbxSfcSwy7w6riZ/vtArvu6d53/UV2pTtiX/upPmO7+UtKTe3Ow8aSuZaZ
	Jf8ZWU6yMbuW+h/u9FR6L9hR4D3nsM+KjbEVtdN8j8uzf5q/4obj+UnzUjOylViKMxINtZiL
	ihMBZBVt4wsDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: 'Greg KH' [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, October 24, 2012 12:01 PM
> To: Jaegeuk Kim
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; viro@zeniv.linux.org.uk;
> arnd@arndb.de; tytso@mit.edu; chur.lee@samsung.com; cm224.lee@samsung.com; jooyoung.hwang@samsung.com
> Subject: Re: [PATCH 00/16 v2] f2fs: introduce flash-friendly file system
> Importance: High
> 
> On Wed, Oct 24, 2012 at 08:14:44AM +0900, Jaegeuk Kim wrote:
> > > On Tue, Oct 23, 2012 at 11:21:53AM +0900, Jaegeuk Kim wrote:
> > > > mkfs.f2fs
> > > > =========
> > > >
> > > > The file system formatting tool, "mkfs.f2fs", is available from the following
> > > > download page:		http://sourceforge.net/projects/f2fs-tools/
> > >
> > > Is there a git tree of this tool somewhere, so I don't have to
> > > constantly suffer the sf.net download interface every time I want to get
> > > the latest version?
> >
> > I'd love to do like that.
> > I've managed a git tree for tools in house only, due to the company secret.
> > Would you suggest something for this?
> > I can do managing the tree outside though.
> 
> git.kernel.org can work, so can github, and also, you have a sf.net
> project, why not use the git tree it provides you?  Right now it is
> empty.
> 

Ok, I'll make a tree in sf.net. :)

> thanks,
> 
> greg k-h


---
Jaegeuk Kim
Samsung



