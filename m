Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab0CYMds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:33:48 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:58178 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab0CYMdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:33:47 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Nikolaus Schulz <microschulz@web.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Marton Balint <cus@fazekas.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Kevin Dankwardt <k@kcomputing.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] fat: fix buffer overflow in vfat_create_shortname()
References: <20100325035010.GA3242@penelope.zusammrottung.local>
	<8739zp6k9s.fsf@devron.myhome.or.jp>
	<20100325122419.GA8896@luigi.zusammrottung.local>
Date: Thu, 25 Mar 2010 21:33:39 +0900
In-Reply-To: <20100325122419.GA8896@luigi.zusammrottung.local> (Nikolaus
	Schulz's message of "Thu, 25 Mar 2010 13:24:19 +0100")
Message-ID: <87y6hg60nw.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikolaus Schulz <microschulz@web.de> writes:

>> However, anyway, your patch is much better off than current one. So,
>> I'll apply this in the next merge window.
>> 
>> Or should we apply this immediately?
>> 
>> Thanks.
>
> Given that this fixes a stack corruption which triggers the gcc stack
> smashing protection and thus basically a crash, I vote for not
> postponing it, but applying it immediately.

Um..., where is a stack corruption? sprintf() overflow? But, it's
actually snprintf(), not sprintf()...

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
