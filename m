Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935910Ab2JaVsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:48:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19860 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759992Ab2JaVst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:48:49 -0400
X-AuditID: cbfee61b-b7f616d00000319b-8b-50919cc00101
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Greg KH'" <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
 <004d01cdb74d$07583b00$1608b100$%kim@samsung.com>
 <20121031155140.GB31543@kroah.com>
In-reply-to: <20121031155140.GB31543@kroah.com>
Subject: RE: [PATCH 16/17] f2fs: move proc files to debugfs
Date: Thu, 01 Nov 2012 06:48:47 +0900
Message-id: <00f501cdb7b1$81ba5860$852f0920$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac23f6Fjd3HkMJBoTG2iR+6V5Y3BSgAMWyAA
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zA90DcyYGGNzoYrbYs/cki8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MrYv24ze8FXroqVN9YzNjC+5+hi5OSQEDCRWHLvMDOE
	LSZx4d56NhBbSGAZo0TPXAuYmgeH+li7GLmA4tMZJf73drJAOP+Ait5sBOrm4GAT0JbYvN8A
	pEFEQEvi2bEdzCA1zAKHGSU+PVoM1TCNUWL26qOsIFWcAvoS9zesBrOFBawletu+M4LYLAKq
	Eu+WzmMCsXkFbCXOvDzODGELSvyYfI8FxGYW0JP4+Oc2I4QtL7F5zVuwIyQE1CUe/dUFMUUE
	jCT2TmCHqBCXmPTgITvEdAGJb5MPsUBUy0psOgB2poTAOnaJjqtPoAEhKXFwxQ2WCYwSs5As
	noVk8Swki2chWbGAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRkiMSe9gXNVgcYhRgINR
	iYd3Qt3EACHWxLLiytxDjBIczEoivI+7gUK8KYmVValF+fFFpTmpxYcYfYAun8gsJZqcD4z/
	vJJ4Q2NjEzMTUxNzS1NzUxzCSuK8zR4pAUIC6YklqdmpqQWpRTDjmDg4pRoYY8++s6yYtml6
	ou53+4tTZksUzXl+dvs811K+p4olLYX5XyMCZiv7pt/Y15W9Qq9AJ72o8LGu69PNy2c6yfWf
	vWmzTrRMc/ZU0deJHatlHvGfP/TM/tv0Vd6zTh7UrDrrv4c58eLDVv1N9fbiL4KZ7jYczAuT
	yzw9awYT1yc77lvf7/oxHJ3SpcRSnJFoqMVcVJwIAP6HJHHeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQd39cyYGGHzcbmOxZ+9JFovLu+aw
	OTB5fN4kF8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQM0WkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsX/dZvaCr1wV
	K2+sZ2xgfM/RxcjJISFgIvHgUB8rhC0mceHeerYuRi4OIYHpjBL/eztZIJx/jBI9bzYydzFy
	cLAJaEts3m8A0iAioCXx7NgOZpAaZoHDjBKfHi2GapjGKDF79VGwsZwC+hL3N6wGs4UFrCV6
	274zgtgsAqoS75bOYwKxeQVsJc68PM4MYQtK/Jh8jwXEZhbQk/j45zYjhC0vsXnNW7AjJATU
	JR791QUxRQSMJPZOYIeoEJeY9OAh+wRGoVlIBs1CMmgWkkGzkLQsYGRZxSiaWpBcUJyUnmuk
	V5yYW1yal66XnJ+7iREcw8+kdzCuarA4xCjAwajEwzuhbmKAEGtiWXFl7iFGCQ5mJRHex91A
	Id6UxMqq1KL8+KLSnNTiQ4w+QH9OZJYSTc4Hppe8knhDYxMzI0sjMwsjE3NzHMJK4rzNHikB
	QgLpiSWp2ampBalFMOOYODilgKnp3ybP/9e9t6pIJUyY221U82THbWmGFJ/9fVOO+7w5/nK7
	4B3/UMklT8N2r/vz5k4V29l1Ky31zzXUi158Y7rn7qpJV7bfX2awsMyq89YTuSvsX6IYVx3Y
	XPSJ5ebVfTFb7jUU2UZph/0TfyA9669r1XfTq0pf39kovfTs+r30wdQDafOM+S6xK7EUZyQa
	ajEXFScCAOjCShkOAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My apologies...
I should have examined the patch itself more carefully.
I'll resend.
Thanks,

---
Jaegeuk Kim
Samsung


> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, November 01, 2012 12:52 AM
> To: Jaegeuk Kim
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; viro@zeniv.linux.org.uk;
> arnd@arndb.de; tytso@mit.edu; chur.lee@samsung.com; cm224.lee@samsung.com; jooyoung.hwang@samsung.com
> Subject: Re: [PATCH 16/17] f2fs: move proc files to debugfs
> Importance: High
> 
> On Wed, Oct 31, 2012 at 06:49:32PM +0900, Jaegeuk Kim wrote:
> > This moves all of the f2fs debugging files into debugfs. The files are
> > located in /sys/kernel/debug/f2fs/
> >
> > Note, I think we are generating all of the same information in each of
> > the files for every unique f2fs filesystem in the machine.  This copies
> > the functionality that was present in the proc files, but this should be
> > fixed up in the future.
> >
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Acked-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> 
> As I wrote this, you need to keep the "From: Greg..." as the first line
> in the changelog so it properly gets attributed when it gets applied.
> 
> See the file Documentation/SubmittingPatches for more details of this.
> 
> thanks,
> 
> greg k-h

