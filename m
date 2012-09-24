Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab2IXGbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 02:31:40 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:42264 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab2IXGbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 02:31:39 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 2/5] fat: allocate persistent inode numbers
References: <1347798148-2660-1-git-send-email-linkinjeon@gmail.com>
	<87lig28fak.fsf@devron.myhome.or.jp>
	<CAKYAXd-6k7=RmrweR=wTOET50hy8Y7LokCSe1c2JtYd7pzPmsQ@mail.gmail.com>
	<87ipb45914.fsf@devron.myhome.or.jp>
	<CAKYAXd9EzKH_x1GaXvSZ7pRebfOcwQqNp6-oEnc2z2evuNo23g@mail.gmail.com>
Date: Mon, 24 Sep 2012 15:31:35 +0900
In-Reply-To: <CAKYAXd9EzKH_x1GaXvSZ7pRebfOcwQqNp6-oEnc2z2evuNo23g@mail.gmail.com>
	(Namjae Jeon's message of "Mon, 24 Sep 2012 13:58:24 +0900")
Message-ID: <87ehls53ug.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> What is problem if i_ino + i_generation is not match? I think, even if
>> those didn't match, i_pos in FH should resolve issue, no?
> No, It can not resolve issue.
> in NFS file handle, there is a reference to the current inode number.
> So, if by eviction that is changed - that it will results in "file id
> changed" error.

Who returns error?

> even though using the i_pos we can reconstruct and get the INODE on
> the Server, but the NFS handle is no more valid. As the inode number
> is also changed, iunique() for the file will result in different
> number this time.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
