Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab1CCW0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:26:21 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:45975 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab1CCW0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:26:19 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] st_nlink after rmdir() and rename()
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
	<AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
	<20110303060352.GK22723@ZenIV.linux.org.uk>
	<AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
	<87tyfk7x0c.fsf@devron.myhome.or.jp>
	<AANLkTinJPQtcBQsBd+OmioywcxSgzWXFgqMBSrfx8e6D@mail.gmail.com>
	<87lj0v9984.fsf@devron.myhome.or.jp>
	<AANLkTinSiD3YakBTNfYXrE12YDsDREHX3GzLzCncduTV@mail.gmail.com>
Date: Fri, 04 Mar 2011 07:26:14 +0900
In-Reply-To: <AANLkTinSiD3YakBTNfYXrE12YDsDREHX3GzLzCncduTV@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 3 Mar 2011 13:52:18 -0800")
Message-ID: <87hbbj96yh.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Mar 3, 2011 at 1:37 PM, OGAWA Hirofumi
> <hirofumi@mail.parknet.co.jp> wrote:
>>
>> And I can't only see is why you refuse to make consistent behavior (if
>> you are saying it). It's why I said if it's _really easy_.
>
> The thing is, it really isn't really easy. As mentioned, it's actually
> impossible on NFS, and it's possibly impossible on other filesystems
> too.

I don't know much about NFS though, I imaged the NFS just fill the
stat.st_nlink to return to userland by 0 if sillyrenamed dentry? (of
course, I'm not saying let's emulate "i_nlink >= 1" on all
filesystems. just about i_nlink == 0) I was thinking Al is working for
it...

And yeah, if it doesn't have consistency on system, I would agree it
would not be meaningful.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
