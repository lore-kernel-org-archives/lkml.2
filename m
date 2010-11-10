Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab0KJNxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:53:19 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:54619 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab0KJNxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:53:15 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH 2/2 v2] Unify rest of FAT messages.
References: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net>
	<1289329470-14454-1-git-send-email-bug-track@fisher-privat.net>
	<87hbfppfu3.fsf@devron.myhome.or.jp> <1289392908.6057.44.camel@zwerg>
Date: Wed, 10 Nov 2010 22:53:09 +0900
In-Reply-To: <1289392908.6057.44.camel@zwerg> (Alexey Fisher's message of
	"Wed, 10 Nov 2010 13:41:48 +0100")
Message-ID: <87d3qdp9oa.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Fisher <bug-track@fisher-privat.net> writes:

> Am Mittwoch, den 10.11.2010, 20:40 +0900 schrieb OGAWA Hirofumi:
>> Alexey Fisher <bug-track@fisher-privat.net> writes:
>> 
>> > Here is how it looks like after patch.
>> 
>> This is going to unify the all FSes (e.g. fat_msg() uses fs_msg("FAT", ...))?
>> If so, I think it's welcome. If not, umm, it looks like good but...
>
> Yea, i thought about it. It will be better to have some kernel wide
> fs_msg(). But before doing this i think one more step should be done -
> some notification interface for userspace. 
> If we get some fs errors userspace app should be notified so user too.
>
> I work currently on one case, user lost all data on FAT drive. First
> error messages was logged for some weeks, and only now some big data
> lost. There war no errors from GUI.

It clealy can happen on all FSes, not only FAT. And I don't want to push
it (notification stuff) from FAT tree. (need the review from other guys).

IMHO, it should be kernel wide (or subsystem wide) notification system
even if you target is FAT-fs only.  (yeah, it's hard to push to
linus-tree than one FS though).

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
