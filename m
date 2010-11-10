Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab0KJQlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:41:06 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:45374 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947Ab0KJQlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:41:05 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH 2/2 v2] Unify rest of FAT messages.
References: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net>
	<1289329470-14454-1-git-send-email-bug-track@fisher-privat.net>
	<87hbfppfu3.fsf@devron.myhome.or.jp> <1289392908.6057.44.camel@zwerg>
	<87d3qdp9oa.fsf@devron.myhome.or.jp> <1289401644.2438.34.camel@mini>
Date: Thu, 11 Nov 2010 01:40:59 +0900
In-Reply-To: <1289401644.2438.34.camel@mini> (Alexey Fisher's message of "Wed,
	10 Nov 2010 16:07:24 +0100")
Message-ID: <878w11p1wk.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Fisher <bug-track@fisher-privat.net> writes:

>> It clealy can happen on all FSes, not only FAT. And I don't want to push
>> it (notification stuff) from FAT tree. (need the review from other guys).
>
> I do not blame FAT. It was just one example/usecase.

Yes. It is why I said the below.

>> IMHO, it should be kernel wide (or subsystem wide) notification system
>> even if you target is FAT-fs only.  (yeah, it's hard to push to
>> linus-tree than one FS though).
>
> Sound complicated. I will not get time for this, right now. Any way, at
> least if this patch set go upstream it will help investigate some FS
> related issues. For my work (Computer Forensic) it will be really
> helpful.

Also, yes. It would be complicate more or less than one FS. And maybe I
can understand why you want to concentrate FAT.

But I'm afraid to implement for only FAT. If there is not any some sort
of agreement by others, it may have to re-implement. If that happen, FAT
can be bothered by compatible (or have to maintain both of old and new
for a while). Because the notified data are some sort of ABI, IMO.

This is why I'm careful about this, and can't say easily - "let's try it
on FAT".

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
