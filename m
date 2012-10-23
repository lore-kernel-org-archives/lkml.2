Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab2JWLiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 07:38:05 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37975 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab2JWLiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 07:38:03 -0400
MIME-Version: 1.0
In-Reply-To: <873915k4ke.fsf@devron.myhome.or.jp>
References: <1349598764-3252-1-git-send-email-linkinjeon@gmail.com>
	<877gqu90x1.fsf@devron.myhome.or.jp>
	<CAKYAXd9Bv4Vv1sk0u9t0d3UubUy8DvTty=WNOFyDxwRuQh=CxA@mail.gmail.com>
	<873915k4ke.fsf@devron.myhome.or.jp>
Date: Tue, 23 Oct 2012 20:38:02 +0900
Message-ID: <CAKYAXd_cWGA3gMnNYRZMzLnkCjjkoqmCj8TwnZXWb3+sHQWDWQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] fat (exportfs): rebuild directory-inode if
 fat_dget() fails
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/23, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>And this is doing same
>>> thing with readdir, so we will have to clean this up as I said before.
>> When I checked, I didn't understand about same thing readdir and this
>> function yet. Because even though minor conditions match but
>> functionality wise both are different.
>
> Hm, I may not be understanding it correctly. I thought the both are
> looking the key up? The key of readdir is the name, the key of this is
> the logstart.
>
> So, I thought it should be similar. However, I just may be wrong
> somewhere... Well, even if those are possible to merge, it should be
> separated patch though.
Okay, I see. I will post changes after verifying.

Thanks.
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
