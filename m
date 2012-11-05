Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab2KECfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 21:35:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50601 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2KECfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 21:35:53 -0500
MIME-Version: 1.0
In-Reply-To: <1351891622.23963.4.camel@oc2046235844.ibm.com>
References: <CAEH94LjTedn0n00ZtqFxBL=kDA3u8G39q+x79-vPoMYvEKW1gw@mail.gmail.com>
	<CAEH94LgUcAL6RquMZKTrDg87_0J2sEqTsDXUbnhrQ37KuMJ4sg@mail.gmail.com>
	<1351891622.23963.4.camel@oc2046235844.ibm.com>
Date: Mon, 5 Nov 2012 10:35:50 +0800
Message-ID: <CAEH94LiuKGPi+k=pA9P-FFsosnwG7PRBK5DjjaGf20S+pyrzpA@mail.gmail.com>
Subject: Re: VFS hot tracking: How to calculate data temperature?
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: cmm@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
        Dave Chinner <david@fromorbit.com>, Ben Chociej <bchociej@gmail.com>,
        James Northrup <northrup.james@gmail.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 3, 2012 at 5:27 AM, Mingming.cao <cmm@us.ibm.com> wrote:
> On Fri, 2012-11-02 at 14:38 +0800, Zhi Yong Wu wrote:
>> Here also has another question.
>>
>> How to save the file temperature among the umount to be able to
>> preserve the file tempreture after reboot?
>>
>> This above is the requirement from DB product.
>> I thought that we can save file temperature in its inode struct, that
>> is, add one new field in struct inode, then this info will be written
>> to disk with inode.
>>
>> Any comments or ideas are appreciated, thanks.
>>
>>
>
> Maybe could save the last file temperature with extended attributes.
It seems that only ext4 has the concept of extended attributes.

> Just save the per-inode temperature only for now.
>
> Mingming
>> On Fri, Nov 2, 2012 at 12:04 PM, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
>> > HI, guys
>> >
>> >    VFS hot tracking currently show result as below, and it is very
>> > strange and not nice.
>> >
>> > inode #279, reads 0, writes 1, avg read time 18446744073709551615,
>> > avg write time 5251566408153596, temp 109
>> >
>> > Do anyone know if there is one simpler but effective way to calculate
>> > data temperature?
>> >
>> > --
>> > Regards,
>> >
>> > Zhi Yong Wu
>>
>>
>>
>
>
>



-- 
Regards,

Zhi Yong Wu
