Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab2JKDPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 23:15:02 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63208 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab2JKDPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 23:15:00 -0400
MIME-Version: 1.0
In-Reply-To: <009f01cda6cb$b8cb1020$2a613060$%kim@samsung.com>
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
Date: Thu, 11 Oct 2012 12:14:58 +0900
Message-ID: <CAKYAXd_6MheUVRm7HVofXVp-HWStZNVw2GCqXNfKukxbJ5rG5g@mail.gmail.com>
Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Jaegeuk Kim <jaegeuk.kim@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        tytso@mit.edu, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/10 Jaegeuk Kim <jaegeuk.kim@samsung.com>:

>>
>> I mean that every volume is placed inside any partition (MTD or GPT). Every partition begins from any
>> physical sector. So, as I can understand, f2fs volume can begin from physical sector that is laid
>> inside physical erase block. Thereby, in such case of formating the f2fs's operation units will be
>> unaligned in relation of physical erase blocks, from my point of view. Maybe, I misunderstand
>> something but it can lead to additional FTL operations and performance degradation, from my point of
>> view.
>
> I think mkfs already calculates the offset to align that.
I think this answer is not what he want.
If you don't use partition table such as dos partition table or gpt, I
think that it is possible to align using mkfs.
But If we should consider partition table space in storage, I don't
understand how it  could be align using mkfs.

Thanks.
> Thanks,
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
