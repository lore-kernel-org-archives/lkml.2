Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052Ab2JWXOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:14:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:62307 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2JWXOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:14:47 -0400
X-AuditID: cbfee61b-b7f616d00000319b-63-508724e51916
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Greg KH'" <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <20121023182659.GA6587@kroah.com>
In-reply-to: <20121023182659.GA6587@kroah.com>
Subject: RE: [PATCH 00/16 v2] f2fs: introduce flash-friendly file system
Date: Wed, 24 Oct 2012 08:14:44 +0900
Message-id: <012e01cdb174$3068f540$913adfc0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2xTACkAeJSD+icT1uLSnZtvRzh+AAI58GQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t8zY92nKu0BBkt+ilns2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWsWX+YsaCBteJLbyNzA+Nn5i5GDg4JAROJlun5XYyc
	QKaYxIV769m6GLk4hASWMUrMXPYErqZpWi5EfBGjxN6/p5ggnH+MEsd3vGEFKWIT0JbYvN8A
	ZJCIgJbEs2M7mEFqmAUOM0p8erSYBSQhJJAo0XJjGSOIzSmgJ3Fo0lZWEFtYwENi7buFYHEW
	AVWJ+VuaweK8ArYS7yYfYYewBSV+TL7HArKLGaj3/kUtkDCzgLzE5jVvoe5Ul3j0VxfiBCOJ
	D9ceMkOUiEjse/EOarqAxLfJh1ggymUlNh0Au1JCYB27xPuLb5kh4SApcXDFDZYJjBKzkCye
	hbB4FpLFs5BsWMDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjJLqkdzCuarA4xCjAwajE
	w5t4oi1AiDWxrLgy9xCjBAezkgjv5LtAId6UxMqq1KL8+KLSnNTiQ4w+QIdPZJYSTc4HRn5e
	SbyhsbGJmYmpibmlqbkpDmElcd5mj5QAIYH0xJLU7NTUgtQimHFMHJxSDYxJNsd/hxksW/Bm
	0cP5ZoqPA/XCLY2F50nkPWf3YuX6laieZeC66WWCR8jXCQwM99yO2ApLfzGdo2LjZbQy5+tz
	hu2xElu+vH3w7ufhupofzlb5R387fbe5UJtppd+ptbJap6xivqrXj8OLdcVzt7PtL56ySDFN
	NsSmvVEjZsXTHDVezUNNPkosxRmJhlrMRcWJAOVIRprbAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jAd2nKu0BBr0fhS327D3JYnF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz1qw/zFjQwFrx
	pbeRuYHxM3MXIweHhICJRNO03C5GTiBTTOLCvfVsXYxcHEICixgl9v49xQTh/GOUOL7jDStI
	A5uAtsTm/QYgDSICWhLPju1gBqlhFjjMKPHp0WIWkISQQKJEy41ljCA2p4CexKFJW1lBbGEB
	D4m17xaCxVkEVCXmb2kGi/MK2Eq8m3yEHcIWlPgx+R4LyC5moN77F7VAwswC8hKb17yFulld
	4tFfXYgTjCQ+XHvIDFEiIrHvxTvGCYxCs5AMmoUwaBaSQbOQdCxgZFnFKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERy9z6R3MK5qsDjEKMDBqMTDm3iiLUCINbGsuDL3EKMEB7OSCO/ku0Ah
	3pTEyqrUovz4otKc1OJDjD5Ab05klhJNzgcmlrySeENjEzMjSyMzCyMTc3McwkrivM0eKQFC
	AumJJanZqakFqUUw45g4OKUaGHmLF67nq3G+vnV7yFfna1n8u4TLcrm+iZ7z8vzd+fhDxvET
	HgISypJ7Wovc50l9+D5T/NzJsLuldedkF5w6u3fJRv2jdZ9/yaxfu1lc85zdeZaXz+tvdT+b
	ozQnNTBD44Ab27XqRa+Epx65n33xcvIb7riGng/N9pP+7JzYvWzPlo97bHOtGHuUWIozEg21
	mIuKEwE2nVngCwMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Oct 23, 2012 at 11:21:53AM +0900, Jaegeuk Kim wrote:
> > mkfs.f2fs
> > =========
> >
> > The file system formatting tool, "mkfs.f2fs", is available from the following
> > download page:		http://sourceforge.net/projects/f2fs-tools/
> 
> Is there a git tree of this tool somewhere, so I don't have to
> constantly suffer the sf.net download interface every time I want to get
> the latest version?

I'd love to do like that.
I've managed a git tree for tools in house only, due to the company secret.
Would you suggest something for this?
I can do managing the tree outside though.

> 
> thanks,
> 
> greg k-h

