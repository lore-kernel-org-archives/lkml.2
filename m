Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab1C2GhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:37:22 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:48459 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1C2GhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:37:20 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v6] fat: Batched discard support for fat
References: <20110328103431.GA22323@july> <87k4fi4iwq.fsf@devron.myhome.or.jp>
	<AANLkTinGPxxTaCzDUfgK7QX6C-AWim5ZJUub1BgCw4YC@mail.gmail.com>
Date: Tue, 29 Mar 2011 15:37:17 +0900
In-Reply-To: <AANLkTinGPxxTaCzDUfgK7QX6C-AWim5ZJUub1BgCw4YC@mail.gmail.com>
	(Kyungmin Park's message of "Tue, 29 Mar 2011 14:11:35 +0900")
Message-ID: <87d3la4ele.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park <kmpark@infradead.org> writes:

>> Again, this ioctl's design is unclear, and seems to be strange. I
>> wouldn't want to add this before clearing it. Please explain what is
>> right behavior.
>
> Umm it's out of my scope. it's trim design.
> See also btrfs batched discard support. it's also no consideration as
> you mentioned.
>
> As I know, now xfs, ext4, and btrfs support this fstrim without these concern.
>
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/9758

I looked at fstrim.c. It is lowlevel tools to just issue FITRIM - it
doesn't use the result at all.

Um. Honestly I'd like to see more or wait until real user for now,
instead of providing unclear design.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
