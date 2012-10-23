Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab2JWHxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:53:12 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:53776 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2JWHxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:53:11 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v4 3/4] fat (exportfs): rebuild directory-inode if fat_dget() fails
References: <1349598764-3252-1-git-send-email-linkinjeon@gmail.com>
	<877gqu90x1.fsf@devron.myhome.or.jp>
	<CAKYAXd9Bv4Vv1sk0u9t0d3UubUy8DvTty=WNOFyDxwRuQh=CxA@mail.gmail.com>
Date: Tue, 23 Oct 2012 16:53:05 +0900
In-Reply-To: <CAKYAXd9Bv4Vv1sk0u9t0d3UubUy8DvTty=WNOFyDxwRuQh=CxA@mail.gmail.com>
	(Namjae Jeon's message of "Tue, 23 Oct 2012 16:34:39 +0900")
Message-ID: <873915k4ke.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>And this is doing same
>> thing with readdir, so we will have to clean this up as I said before.
> When I checked, I didn't understand about same thing readdir and this
> function yet. Because even though minor conditions match but
> functionality wise both are different.

Hm, I may not be understanding it correctly. I thought the both are
looking the key up? The key of readdir is the name, the key of this is
the logstart.

So, I thought it should be similar. However, I just may be wrong
somewhere... Well, even if those are possible to merge, it should be
separated patch though.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
