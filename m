Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2JWDV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 23:21:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50844 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab2JWDVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 23:21:25 -0400
X-AuditID: cbfee61b-b7f616d00000319b-c4-50860d336bc9
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Greg KH'" <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <002001cdb0c6$c9527550$5bf75ff0$%kim@samsung.com>
 <20121023030407.GA22018@kroah.com>
In-reply-to: <20121023030407.GA22018@kroah.com>
Subject: RE: [PATCH 16/16 v2] f2fs: update Kconfig and Makefile
Date: Tue, 23 Oct 2012 12:21:23 +0900
Message-id: <002701cdb0cd$7ab32f00$70198d00$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2wywFIMY4QrTuGTzixqvqdyfSqIAAAXCuw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zY11j3rYAgw0bbCz27D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDImv1UuOMRRsf70fPYGxkNsXYycHBICJhKNT5uYIWwx
	iQv31gPFuTiEBJYxSjS2T4ErmnaqFyqxiFGiqbuPHcL5xyhx6Pgz1i5GDg42AW2JzfsNQBpE
	BLQknh3bwQxSwyxwmFHi06PFLBAN0xglJj/vZgWp4hTQl/jZ0wa2W1jAXuLg5NvMIINYBFQl
	jjxwAAnzCthKLN4/mxHCFpT4MfkeC0gJs4CexP2LWiBhZgF5ic1r3oJ1SgioSzz6qwtxgpHE
	xu8f2CBKRCT2vXgHNoVFQEDi2+RDLBDlshKbDoBdKSGwjl1izYmHjBD/SkocXHGDZQKjxCwk
	i2chLJ6FZPEsJBsWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiJL+kdjKsaLA4xCnAw
	KvHwduxvDRBiTSwrrsw9xCjBwawkwqscABTiTUmsrEotyo8vKs1JLT7E6AN0+ERmKdHkfGDs
	55XEGxobm5iZmJqYW5qam+IQVhLnbfZICRASSE8sSc1OTS1ILYIZx8TBKdXAmCv2T3WJzP2e
	Oue04oUpNcvVHvccqJ0fEXpO9/7L7W2buQ9OWM40JchW545bgOtr7WMH30as2C3ZfVV4/wqj
	gDsTN3qJZV5tVNezrOh+d+PFzAlcose1w75Vnbym3cO06IXUmesng1c7rJ1Wwvs+9o6N/q4K
	9c9LhLSd4u6Wz+iQsvUMFbsSosRSnJFoqMVcVJwIAGiR6tXcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jAV1j3rYAgy9fLCz27D3JYnF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzJr9VLjjEUbH+
	9Hz2BsZDbF2MnBwSAiYS0071QtliEhfurQeyuTiEBBYxSjR197FDOP8YJQ4df8baxcjBwSag
	LbF5vwFIg4iAlsSzYzuYQWqYBQ4zSnx6tJgFomEao8Tk592sIFWcAvoSP3vamEFsYQF7iYOT
	bzODDGIRUJU48sABJMwrYCuxeP9sRghbUOLH5HssICXMAnoS9y9qgYSZBeQlNq95C9YpIaAu
	8eivLsQJRhIbv39ggygRkdj34h3jBEahWUgGzUIYNAvJoFlIOhYwsqxiFE0tSC4oTkrPNdIr
	TswtLs1L10vOz93ECI7eZ9I7GFc1WBxiFOBgVOLh7djfGiDEmlhWXJl7iFGCg1lJhFc5ACjE
	m5JYWZValB9fVJqTWnyI0Qfoy4nMUqLJ+cDEklcSb2hsYmZkaWRmYWRibo5DWEmct9kjJUBI
	ID2xJDU7NbUgtQhmHBMHp1QDY+ACt5O2TMz9xyZanF8wwWP3mqTyqLlntpsoVmqtTGe9uv/N
	L3fRaa5HzjHcOFe1iOdktJRe5by0AtlJi9cUvDn3+9LskqXO514cUSjb7H+gYSPDzby3Wx2n
	65q+DRdvavvxR2jqSpf+Xz1PpEWO6u6zOeo1NUg1Xr/bTaD6wbMJCooWHPxvviqxFGckGmox
	FxUnAgC5QRqXCwMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Oct 23, 2012 at 11:33:28AM +0900, Jaegeuk Kim wrote:
> > +config F2FS_STAT_FS
> > +	bool "F2FS Status Information"
> > +	depends on F2FS_FS
> > +	default y
> > +	help
> > +	  /proc/fs/f2fs/ contains information about partitions mounted as f2fs.
> > +	  For each partition, a corresponding directory, named as its device
> > +	  name, is provided with the following proc entries.
> > +
> > +	  f2fs_stat	major file system information managed by f2fs currently
> > +	  f2fs_sit_stat	average SIT information about whole segments
> > +	  f2fs_mem_stat	current memory footprint consumed by f2fs
> > +
> > +	  e.g., in /proc/fs/f2fs/sdb1/
> 
> Again, I will point out that this should either be in debugfs, or in
> /sys/fs/ but it should NOT be in /proc/ at all.
> 
> If you need help, I will be glad to do this conversion, just let me know
> and I'll send you a patch on top of this series that moves these entries
> into debugfs, which is where I think they really belong.

Ok, please. :)
I really appreciate your kindness.

> 
> thanks,
> 
> greg k-h

