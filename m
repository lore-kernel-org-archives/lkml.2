Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2EELbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 07:31:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52518 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2EELbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 07:31:21 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20120503141156.GP6871@ZenIV.linux.org.uk>
References: <1335669917-23970-1-git-send-email-vapier@gentoo.org>
 <CAKgNAkgykZJV59WJXW9c9gVwXhn=WNYKxo_W1GM7ocHEEFqEXg@mail.gmail.com>
 <877gwxacti.fsf@skywalker.in.ibm.com> <CAKgNAkiRH8p=Dp1tqkb3D9oRVCOSnj2bofgFN5x2svntN7vtPg@mail.gmail.com>
 <87bom5xswc.fsf@skywalker.in.ibm.com> <20120503141156.GP6871@ZenIV.linux.org.uk>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sat, 5 May 2012 23:31:00 +1200
Message-ID: <CAKgNAkjmSUDU9yk1UX=fSeSZfH4kgoQTUg6YeidZ9-fsOfJKAQ@mail.gmail.com>
Subject: Re: [PATCH] open(2): document O_PATH
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-man@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 2:11 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, May 03, 2012 at 07:34:35PM +0530, Aneesh Kumar K.V wrote:
>
>> I looked at dnotify_flush, they remove markers on an inode.
>> But then it also checks for filp to match. So I am not sure
>> whether skipping dnotify_flush for O_PATH descriptor have any impact. We
>> can't use O_PATH descriptor for dnotify fcntl any way. So in
>> dnotify_flush we will not match the filp.
>>
>> Viro,
>>
>> Any reason why we skip dnotify_flush  ?
>
> See your last sentence above - why bother finding the mark, scanning the
> list, etc. when we know that there won't be any matches?

So, am I correct to understand that O_PATH has no interaction with dnotify?

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
