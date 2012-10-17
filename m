Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab2JQXGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 19:06:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13684 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab2JQXGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 19:06:34 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-1d-507f39f9529a
From: Changman Lee <cm224.lee@samsung.com>
To: "'Namjae Jeon'" <linkinjeon@gmail.com>,
        "'Changman Lee'" <cm224.lee@gmail.com>
Cc: "'Jaegeuk Kim'" <jaegeuk.kim@samsung.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, tytso@mit.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, jooyoung.hwang@samsung.com,
        linux-fsdevel@vger.kernel.org
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com>
 <9DE65D03-D4EA-4B32-9C1D-1516EAE50E23@dubeyko.com>
 <1349553966.12699.132.camel@kjgkr> <50712AAA.5030807@gmail.com>
 <002201cda46e$88b84d30$9a28e790$%kim@samsung.com>
 <F7EA5AF7-8A1C-4C98-90AF-9D47E39731AB@dubeyko.com>
 <004101cda52e$72210e20$56632a60$%kim@samsung.com>
 <55A93BD0-CBCB-4707-A970-EB823EC54B2D@dubeyko.com>
 <006f01cda5ec$e63e9b60$b2bbd220$%kim@samsung.com>
 <1349855868.1889.87.camel@slavad-ubuntu>
 <009f01cda6cb$b8cb1020$2a613060$%kim@samsung.com>
 <CAKYAXd_6MheUVRm7HVofXVp-HWStZNVw2GCqXNfKukxbJ5rG5g@mail.gmail.com>
 <CAN863PuyMkSZtZCvqX+kwei9v=rnbBYVYr3TqBXF_6uxwJe2_Q@mail.gmail.com>
 <CAKYAXd9+fEVUhe7kRcv_CnWhH3z_e4NqPstSWoCQ6xqrSt4AyQ@mail.gmail.com>
In-reply-to: <CAKYAXd9+fEVUhe7kRcv_CnWhH3z_e4NqPstSWoCQ6xqrSt4AyQ@mail.gmail.com>
Subject: RE: [PATCH 00/16] f2fs: introduce flash-friendly file system
Date: Thu, 18 Oct 2012 08:06:32 +0900
Message-id: <000001cdacbc$0ca68080$25f38180$%lee@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2sWIOvEJLpWExaSKuidsCI/S9VsQAX7Zmw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQd2flvUBBgtahS327D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDI+Xn/IXPBatGLmhi2MDYynBbsYOTkkBEwkVt89xQJh
	i0lcuLeerYuRi0NIYDqjxNf+n1DOX0aJ3V+7GEGq2AS0JNpPrwXrEBHwk5j7YS0rSBGzwBcm
	iT3N0xghOt6zSszZ1MoKUsUpECxx9egLdhBbWMBVov1PO9gkFgFViVtb/zCD2LwCthIn33Wx
	Q9iCEj8m3wPawAE0VV1iypRckDCzgLbEk3cXWEHCEkDhR391IW4wknj0ZT0jRImIxL4X7xgn
	MArNQjJoFsKgWUgGzULSsYCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcEg/k9rBuLLB
	4hCjAAejEg/vh9m1AUKsiWXFlbmHGCU4mJVEeG+z1wcI8aYkVlalFuXHF5XmpBYfYpTmYFES
	5232SAkQEkhPLEnNTk0tSC2CyTJxcEo1MK5pqVe9pz6/RPwAy9Vp33K1Xvyb0ZhYlvXmprew
	2eXgK4H8FV0pcar/z8QEPFv1leXzeglvvxUdE9uuzEh6fnS6r7TQWtNngodUE+9r9y/bJHCX
	Y/pmG7u3LHrftznsvH2UNXLZ9T2Tz/anX1c6PqFn5+q7krMfFxhLKckYds67eOa253Rvs4VK
	LMUZiYZazEXFiQBaFQPYZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Namjae Jeon [mailto:linkinjeon@gmail.com]
> Sent: Wednesday, October 17, 2012 8:14 PM
> To: Changman Lee
> Cc: Jaegeuk Kim; Vyacheslav Dubeyko; Marco Stornelli; Jaegeuk Kim; Al Viro;
> tytso@mit.edu; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> chur.lee@samsung.com; cm224.lee@samsung.com; jooyoung.hwang@samsung.com;
> linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
> 
> 2012/10/11, Changman Lee <cm224.lee@gmail.com>:
> > 2012년 10월 11일 목요일에 Namjae Jeon<linkinjeon@gmail.com>님이 작성:
> >> 2012/10/10 Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> >>
> >>>>
> >>>> I mean that every volume is placed inside any partition (MTD or GPT).
> > Every partition begins from any
> >>>> physical sector. So, as I can understand, f2fs volume can begin from
> > physical sector that is laid
> >>>> inside physical erase block. Thereby, in such case of formating the
> > f2fs's operation units will be
> >>>> unaligned in relation of physical erase blocks, from my point of view.
> > Maybe, I misunderstand
> >>>> something but it can lead to additional FTL operations and performance
> > degradation, from my point of
> >>>> view.
> >>>
> >>> I think mkfs already calculates the offset to align that.
> >> I think this answer is not what he want.
> >> If you don't use partition table such as dos partition table or gpt, I
> >> think that it is possible to align using mkfs.
> >> But If we should consider partition table space in storage, I don't
> >> understand how it  could be align using mkfs.
> >>
> >> Thanks.
> >
> > We can know the physical starting sector address of any partitions from
> > hdio geometry information got by ioctl.
> If so, first block and end block of partition are useless ?
> 
> Thanks.

For example.
If we try to align a start point of F2FS in 2MB but start sector of any partition is not aligned in 2MB,
and of course F2FS will have some unused blocks. Instead, F2FS could reduce gc cost of ftl.
I don't know my answer is what you want.

> >
> >>> Thanks,
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"
> > in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> >> in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> >

