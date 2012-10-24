Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab2JXFfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:35:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12577 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab2JXFf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:35:28 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-13-50877e1e33ae
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Greg KH'" <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <20121023182659.GA6587@kroah.com> <20121023185753.GA2466@kroah.com>
 <013801cdb174$ba5ca990$2f15fcb0$%kim@samsung.com>
 <20121024030241.GD7982@kroah.com>
In-reply-to: <20121024030241.GD7982@kroah.com>
Subject: RE: [PATCH 00/16 v2] f2fs: introduce flash-friendly file system
Date: Wed, 24 Oct 2012 14:35:26 +0900
Message-id: <001c01cdb1a9$5f0d7800$1d286800$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2xk/V0+78+UMfTQoamLrRMb1qyyAAFVqDg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zI125uvYAg3uHzCz27D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLmnj3MXHCUp6LhqW8D41rOLkZODgkBE4klp7qYIGwx
	iQv31rN1MXJxCAksY5SY/3YLE0zR3OYvbCC2kMAiRokti6ohiv4xSvxavIKli5GDg01AW2Lz
	fgOQGhEBLYlnx3Ywg9QwCxxmlPj0aDELRMNtoKlbJ7KDVHEK6Ekc6b8HZgsLeEisfbeQEcRm
	EVCV2DphBTOIzStgK3Hi2UI2CFtQ4sfkeywgNjNQ78c/txkhbHmJzWveMoMcISGgLvHory7E
	EUYSazp/s0OUiEjse/EOaryAxLfJh1ggymUlNh0Au1NCYB27xN2dG9khHpaUOLjiBssERolZ
	SDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjJMakdjCubLA4xCjA
	wajEw5txvi1AiDWxrLgy9xCjBAezkgjv5LtAId6UxMqq1KL8+KLSnNTiQ4w+QJdPZJYSTc4H
	xn9eSbyhsbGJmYmpibmlqbkpDmElcd5mj5QAIYH0xJLU7NTUgtQimHFMHJxSDYzRYaFfzC49
	+XifY73D78B5QUsj2IwOG1ipPor9ePbYdKaijfubZbRWfVVnatjg3qD79nH3RZGWIrWMEwV6
	q64sdrp+0WCJ38LZXI8fayal1V6PaxV4nvw47tmzb1nXZSx5DSYpyc7dYphQkxTHIOjvuuXH
	IrYrL44pKzoJnap8k3tcML8riUeJpTgj0VCLuag4EQAFa55p3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAV25uvYAg8ttRhZ79p5ksbi8aw6b
	A5PH501yAYxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
	um6ZOUCjlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZc88eZi44ylPR
	8NS3gXEtZxcjJ4eEgInE3OYvbBC2mMSFe+vBbCGBRYwSWxZVdzFyAdn/GCV+LV7B0sXIwcEm
	oC2xeb8BSI2IgJbEs2M7mEFqmAUOM0p8erSYBaLhNqPE/K0T2UGqOAX0JI703wOzhQU8JNa+
	W8gIYrMIqEpsnbCCGcTmFbCVOPFsIRuELSjxY/I9FhCbGaj345/bjBC2vMTmNW+ZQY6QEFCX
	ePRXF+III4k1nb/ZIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBEfwM6kdjCsbLA4xCnAwKvHwZpxvCxBiTSwrrsw9xCjBwawkwjv5LlCI
	NyWxsiq1KD++qDQntfgQow/QoxOZpUST84HJJa8k3tDYxMzI0sjMwsjE3ByHsJI4b7NHSoCQ
	QHpiSWp2ampBahHMOCYOTqkGRo8+U6erD+9vUIl2NPvr68q++dbxsFkCxwVvS8084X7l7NSS
	sNkTN33g/n1K4zKL6o3pLLnly5adZTth6WQ1T/PhwtUM/2dts81+HzXpdpjsivZvp65uWX+4
	YPvV2l0rJ4jPm85S/Vc+se7Y/cRtST0PlxYzFKTuTvllZmsStFs1Kz9mzrdFHquUWIozEg21
	mIuKEwG8efi8DQMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Oct 24, 2012 at 08:18:36AM +0900, Jaegeuk Kim wrote:
> > > On Tue, Oct 23, 2012 at 11:26:59AM -0700, Greg KH wrote:
> > > > On Tue, Oct 23, 2012 at 11:21:53AM +0900, Jaegeuk Kim wrote:
> > > > > mkfs.f2fs
> > > > > =========
> > > > >
> > > > > The file system formatting tool, "mkfs.f2fs", is available from the following
> > > > > download page:		http://sourceforge.net/projects/f2fs-tools/
> > > >
> > > > Is there a git tree of this tool somewhere, so I don't have to
> > > > constantly suffer the sf.net download interface every time I want to get
> > > > the latest version?
> > >
> > > Oh, and where do we report bugs for this tool?  I just formatted a usb
> > > stick with the mkfs.f2fs program, and it did not fully erase the old
> > > filesystem that was on there (iso9660), so when I mounted it, it did so
> > > in iso9660 mode, not f2fs mode.
> > >
> >
> > Any suggestion for reporting bugs?
> > Maybe via a mailing list?
> 
> Mailing list is fine.
> 
> > What version did you use? (1.1.0 is correct.)
> 
> I used 1.1.0
> 
> > The reason we found was due to the 0'th block, so we fixed that in v1.1.0.
> 
> Hm, that's what I used.  I zeroed out the whole usb disk and tried again
> and it worked then, I was trying to debug the kernel changes, not the
> userspace tool, so I didn't spend much time on it :)
> 
> But, if you do get a public git tree up, I will at the very least,
> provide a patch to handle '-h' properly for mkfs, that should work...
> 

Ok, thank you very much.

> thanks,
> 
> greg k-h


---
Jaegeuk Kim
Samsung


