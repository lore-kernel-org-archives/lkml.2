Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1GZIwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 04:52:15 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:34450 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab1GZIwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 04:52:06 -0400
MIME-Version: 1.0
In-Reply-To: <20110726082146.GB11939@x4.trippels.de>
References: <20110725185649.GA22133@ZenIV.linux.org.uk>
	<20110726033535.GA11939@x4.trippels.de>
	<CA+55aFzaKHpVdLKac6rFN+YsAugz1aR3fv-reThJiD4HWDND8w@mail.gmail.com>
	<20110726082146.GB11939@x4.trippels.de>
Date: Tue, 26 Jul 2011 16:52:03 +0800
Message-ID: <CADxeRwnYxgxZPT3DN=SraZOvL_juWzV+MoY9+0vqZr29y6U6cA@mail.gmail.com>
Subject: Re: [git pull] vfs pile 1.5
From: Steven Liu <lingjiujianke@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maybe some one have not use #ifdef CONFIG_FS_POSIX_ACL
with  fs/xfs/linux-2.6/xfs_iops.c:1025:14

:)

2011/7/26 Markus Trippelsdorf <markus@trippelsdorf.de>:
> On 2011.07.25 at 21:52 -0700, Linus Torvalds wrote:
>> On Mon, Jul 25, 2011 at 8:35 PM, Markus Trippelsdorf
>> <markus@trippelsdorf.de> wrote:
>> >
>> > This breaks the build for "# CONFIG_FS_POSIX_ACL is not set" configs:
>>
>> Of course it does. And as usual, my exhaustive testing was for the
>> allyesconfig case, rather than doing both allyesconfig and allnoconfig
>> like I should.
>>
>> Bah.
>>
>> Does the attached trivial patch fix everything for you?
>
> Yes, thanks.
>
> But now xfs fails to build when CONFIG_FS_POSIX_ACL is not set:
>
>  CC      fs/xfs/linux-2.6/xfs_xattr.o
> fs/xfs/linux-2.6/xfs_iops.c:1025:14: error: ‘xfs_get_acl’ undeclared here (not in a function)
>
> --
> Markus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
