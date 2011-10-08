Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1JHJyD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 05:54:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64253 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1JHJyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 05:54:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com>
References: <1317943022.1095.25.camel@mop>
	<20111007111231.6e11d18e@lxorguk.ukuu.org.uk>
	<CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com>
	<20111007113820.3b8424a8@lxorguk.ukuu.org.uk>
	<CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com>
Date: Sat, 8 Oct 2011 11:53:59 +0200
Message-ID: <CAE2SPAY=OzVKtgeO=QtT_73EKuJHBWMFkMLA==uG6UUk-pekvQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_A_Plumber=E2=80=99s_Wish_List_for_Linux?=
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        lennart@poettering.net, harald@redhat.com, david@fubar.dk,
        greg@kroah.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 2:46 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> []sorry, need to resend. I tried to reply with the cell phone but it bounces]
>
> On Fri, Oct 7, 2011 at 12:38, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> On Fri, 7 Oct 2011 12:28:46 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:
>>
>>> What do you mean would be ugly?
>>
>> I have an ext4fs. It supports every possible file name allowed by POSIX
>> and SuS. What name are you going to use for your 'hidden directory' that
>> won't clash with a real file ?
>
> Ah, no. The label on FAT (similar on NTFS) are 'magic entries' in the
> root dir list, not a real file in the root dir.

Why not using a special xattr namespace ?

Bastien
> We need kernel support for changing a mounted fs, because, unlike
> ext4, the blocks containing the strings are inside the fs, which the
> kernel might change any time.
>
> Kay
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
