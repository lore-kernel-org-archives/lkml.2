Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab2KEC3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 21:29:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36270 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2KEC3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 21:29:40 -0500
MIME-Version: 1.0
In-Reply-To: <20121102084109.GA19753@gmail.com>
References: <CAEH94LjTedn0n00ZtqFxBL=kDA3u8G39q+x79-vPoMYvEKW1gw@mail.gmail.com>
	<CAEH94LgUcAL6RquMZKTrDg87_0J2sEqTsDXUbnhrQ37KuMJ4sg@mail.gmail.com>
	<20121102084109.GA19753@gmail.com>
Date: Mon, 5 Nov 2012 10:29:39 +0800
Message-ID: <CAEH94LiYoeJEDxuHtK=z1sA5h7kzZQ1Day+U5o1SZDz-m8RYnA@mail.gmail.com>
Subject: Re: VFS hot tracking: How to calculate data temperature?
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>, linux-fsdevel@vger.kernel.org,
        linuxram@linux.vnet.ibm.com, Dave Chinner <david@fromorbit.com>,
        cmm@us.ibm.com, Ben Chociej <bchociej@gmail.com>,
        James Northrup <northrup.james@gmail.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 4:41 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Fri, Nov 02, 2012 at 02:38:29PM +0800, Zhi Yong Wu wrote:
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
>
> Hi Zhiyong,
>
> I think that we might define a callback function.  If a filesystem wants
> to save these data, it can implement a function to save them.  The
> filesystem can decide whether adding it or not by themselves.
Great idea,  temperature saving function is maybe very specific to FS.
But i am wondering if we can find one generic way to save temperature
info at first.

>
> BTW, actually I don't really care about how to save these data because I
> only want to observe which file is accessed in real time, which is very
> useful for me to track a problem in our product system.
heh, but other guys or products care about this.

>
> Regards,
> Zheng



-- 
Regards,

Zhi Yong Wu
