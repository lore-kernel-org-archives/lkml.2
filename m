Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab2KEIpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:45:01 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60694 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab2KEIo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:44:59 -0500
MIME-Version: 1.0
In-Reply-To: <20121105082828.GJ29378@dastard>
References: <CAEH94LjTedn0n00ZtqFxBL=kDA3u8G39q+x79-vPoMYvEKW1gw@mail.gmail.com>
	<CAEH94LgUcAL6RquMZKTrDg87_0J2sEqTsDXUbnhrQ37KuMJ4sg@mail.gmail.com>
	<1351891622.23963.4.camel@oc2046235844.ibm.com>
	<CAEH94LiuKGPi+k=pA9P-FFsosnwG7PRBK5DjjaGf20S+pyrzpA@mail.gmail.com>
	<20121105082828.GJ29378@dastard>
Date: Mon, 5 Nov 2012 16:44:57 +0800
Message-ID: <CAEH94LhbiHdsTCzsH6K8g3WH02_5-dnUPRZBCJW9vtpgAuuGtg@mail.gmail.com>
Subject: Re: VFS hot tracking: How to calculate data temperature?
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
        Ben Chociej <bchociej@gmail.com>,
        James Northrup <northrup.james@gmail.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 4:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Nov 05, 2012 at 10:35:50AM +0800, Zhi Yong Wu wrote:
>> On Sat, Nov 3, 2012 at 5:27 AM, Mingming.cao <cmm@us.ibm.com> wrote:
>> > On Fri, 2012-11-02 at 14:38 +0800, Zhi Yong Wu wrote:
>> >> Here also has another question.
>> >>
>> >> How to save the file temperature among the umount to be able to
>> >> preserve the file tempreture after reboot?
>> >>
>> >> This above is the requirement from DB product.
>> >> I thought that we can save file temperature in its inode struct, that
>> >> is, add one new field in struct inode, then this info will be written
>> >> to disk with inode.
>> >>
>> >> Any comments or ideas are appreciated, thanks.
>> >>
>> >>
>> >
>> > Maybe could save the last file temperature with extended attributes.
>> It seems that only ext4 has the concept of extended attributes.
>
> All major filesystems have xattr support. They are used extensively
> by the security and integrity subsystems, for example.
got it, thanks.
>
> Saving the information might be something that is useful to certian
> applications, but lets have the people that need that functionality
> spell out their requirements before discussing how or what to
> implement.  Indeed, discussion shoul dreally focus on getting the
> core, in-memory infrastructure sorted out first before trying to
> expand the functionality further...
ah, but the latest patchset need some love from experienced FS guys:).......
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu
