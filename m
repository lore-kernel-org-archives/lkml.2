Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab1ISD4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 23:56:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39599 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab1ISD4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 23:56:18 -0400
MIME-Version: 1.0
In-Reply-To: <m2vcsp2om9.fsf@bob.laptop.org>
References: <CAKYAXd8xd3sCi0CCOH6Y3AR2J2iuDQispCnt0D2mksiAWr=rgw@mail.gmail.com>
	<m2vcsp2om9.fsf@bob.laptop.org>
Date: Mon, 19 Sep 2011 12:56:16 +0900
Message-ID: <CAKYAXd9=KE6wwcCQ+Khfy0N6uBizQEvoLCiu9vzbskGHtmsS4A@mail.gmail.com>
Subject: Re: RFC : mmc : boot partition is set as a read-write.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/19 Chris Ball <cjb@laptop.org>:
> Hi,
>
> On Sun, Sep 18 2011, NamJae Jeon wrote:
>> mmc : boot partition is set as a read-write.
>>
>> There is a case that user directly update boot partition through mmcblk0boot0,1.
>> However, the current boot partition is set as a read-only.
>> I suggest that boot partition is set as a read-write if there is no
>> reason that it should be read-only.
>
> There is a reason.
>
> Documentation/mmc/mmc-dev-parts.txt:
>
> MMC Boot Partitions
> ===================
>
> Read and write access is provided to the two MMC boot partitions. Due to
> the sensitive nature of the boot partition contents, which often store
> a bootloader or bootloader configuration tables crucial to booting the
> platform, write access is disabled by default to reduce the chance of
> accidental bricking.
>
> To enable write access to /dev/mmcblkXbootY, disable the forced read-only
> access with:
>
> echo 0 > /sys/block/mmcblkXbootY/force_ro
>
> ==
> - Chris.
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Hi. Chris.

There is the way you are.

Thanks a lot.
