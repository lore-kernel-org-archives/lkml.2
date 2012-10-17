Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2JQLPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:15:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59753 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2JQLN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:13:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAN863PuyMkSZtZCvqX+kwei9v=rnbBYVYr3TqBXF_6uxwJe2_Q@mail.gmail.com>
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com>
	<9DE65D03-D4EA-4B32-9C1D-1516EAE50E23@dubeyko.com>
	<1349553966.12699.132.camel@kjgkr>
	<50712AAA.5030807@gmail.com>
	<002201cda46e$88b84d30$9a28e790$%kim@samsung.com>
	<F7EA5AF7-8A1C-4C98-90AF-9D47E39731AB@dubeyko.com>
	<004101cda52e$72210e20$56632a60$%kim@samsung.com>
	<55A93BD0-CBCB-4707-A970-EB823EC54B2D@dubeyko.com>
	<006f01cda5ec$e63e9b60$b2bbd220$%kim@samsung.com>
	<1349855868.1889.87.camel@slavad-ubuntu>
	<009f01cda6cb$b8cb1020$2a613060$%kim@samsung.com>
	<CAKYAXd_6MheUVRm7HVofXVp-HWStZNVw2GCqXNfKukxbJ5rG5g@mail.gmail.com>
	<CAN863PuyMkSZtZCvqX+kwei9v=rnbBYVYr3TqBXF_6uxwJe2_Q@mail.gmail.com>
Date: Wed, 17 Oct 2012 20:13:57 +0900
Message-ID: <CAKYAXd9+fEVUhe7kRcv_CnWhH3z_e4NqPstSWoCQ6xqrSt4AyQ@mail.gmail.com>
Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
From: Namjae Jeon <linkinjeon@gmail.com>
To: Changman Lee <cm224.lee@gmail.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Jaegeuk Kim <jaegeuk.kim@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chur.lee@samsung.com" <chur.lee@samsung.com>,
        "cm224.lee@samsung.com" <cm224.lee@samsung.com>,
        "jooyoung.hwang@samsung.com" <jooyoung.hwang@samsung.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/11, Changman Lee <cm224.lee@gmail.com>:
> 2012년 10월 11일 목요일에 Namjae Jeon<linkinjeon@gmail.com>님이 작성:
>> 2012/10/10 Jaegeuk Kim <jaegeuk.kim@samsung.com>:
>>
>>>>
>>>> I mean that every volume is placed inside any partition (MTD or GPT).
> Every partition begins from any
>>>> physical sector. So, as I can understand, f2fs volume can begin from
> physical sector that is laid
>>>> inside physical erase block. Thereby, in such case of formating the
> f2fs's operation units will be
>>>> unaligned in relation of physical erase blocks, from my point of view.
> Maybe, I misunderstand
>>>> something but it can lead to additional FTL operations and performance
> degradation, from my point of
>>>> view.
>>>
>>> I think mkfs already calculates the offset to align that.
>> I think this answer is not what he want.
>> If you don't use partition table such as dos partition table or gpt, I
>> think that it is possible to align using mkfs.
>> But If we should consider partition table space in storage, I don't
>> understand how it  could be align using mkfs.
>>
>> Thanks.
>
> We can know the physical starting sector address of any partitions from
> hdio geometry information got by ioctl.
If so, first block and end block of partition are useless ?

Thanks.
>
>>> Thanks,
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"
> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
