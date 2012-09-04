Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab2IDRHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 13:07:44 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:35371 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467Ab2IDRHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 13:07:43 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 4/5] fat: eliminate orphaned inode number allocation
References: <1346774312-8142-1-git-send-email-linkinjeon@gmail.com>
	<87mx15910k.fsf@devron.myhome.or.jp>
Date: Wed, 05 Sep 2012 02:07:40 +0900
In-Reply-To: <87mx15910k.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Wed, 05 Sep 2012 02:00:11 +0900")
Message-ID: <87fw6x90o3.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Maintain a list of inode(i_pos) numbers of orphaned inodes (i.e the
>> inodes that have been unlinked but still having open file
>> descriptors).At file/directory creation time, skip using such i_pos
>> values.Removal of the i_pos from the list is done during inode eviction.
>
> What happens if the directory (has busy entries) was completely removed?
>
>
> And Al's point is important for NFS too. If you want stable ino for NFS,
> you never can't change it.

s/never can't/never can/
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
