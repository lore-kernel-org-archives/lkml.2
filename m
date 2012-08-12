Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab2HLKSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 06:18:23 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:55874 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2HLKSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 06:18:21 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Cruz Julian Bishop <cruzjbishop@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Fat checkstyle patch set (1)
References: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
Date: Sun, 12 Aug 2012 19:18:19 +0900
In-Reply-To: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com> (Cruz
	Julian Bishop's message of "Sun, 12 Aug 2012 19:44:40 +1000")
Message-ID: <877gt4behg.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cruz Julian Bishop <cruzjbishop@gmail.com> writes:

> Hi (and to the mailing list, again).
>
> This is a patch series that fixes checkpatch issues in fs/fat.
>
> I didn't get to do all of the files, but I'll be sure to come back for
> them later :)
>
> Please let me know if I did something wrong - I'll be sure to take it on
> for my next patches.

Is this for -mm tree? Please make sure there is no conflict.

Yeah, small patch is preferred, but it should be the logical separation,
and one patch would be better in this case, IMHO.

Personally, I'm not against this type cleanup only if there is no
conflict though (i.e. doesn't increase maintain cost). So, if akpm is
fine to take this, then I'm ok.

> Cruz Julian Bishop (7):
>   fs/fat: Fix a checkpatch issue in namei_msdos.c
>   fs/fat: Fix some checkpatch issues in fat.h
>   fs/fat: Changed indentation of some comments in fat.h
>   fs/fat: Fix two checkstyle issues in cache.c
>   fs/fat: Fixes some small checkpatch issues is dir.c
>   fs/fat: Fix all other checkstyle issues in dir.c
>   fs/fat: Fix checkpatch issues in fatent.c

There was one strange new line in a patch. Otherwise,

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
