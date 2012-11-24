Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197Ab2KXJPi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 04:15:38 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38170 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789Ab2KXJPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 04:15:35 -0500
Message-ID: <50B08EA6.6030108@gmail.com>
Date: Sat, 24 Nov 2012 10:08:54 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] hostfs: fix a not needed double check
References: <508276D3.5000708@gmail.com> <50A8A382.7020400@gmail.com> <50B08D28.40809@gmail.com> <20121124101220.75802fd1@spider.haslach.nod.at>
In-Reply-To: <20121124101220.75802fd1@spider.haslach.nod.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/11/2012 10:12, Richard Weinberger ha scritto:
> Am Sat, 24 Nov 2012 10:02:32 +0100
> schrieb Marco Stornelli <marco.stornelli@gmail.com>:
>
>> Il 18/11/2012 09:59, Marco Stornelli ha scritto:
>>> Il 20/10/2012 12:02, Marco Stornelli ha scritto:
>>>> With the commit 3be2be0a32c18b0fd6d623cda63174a332ca0de1 we removed
>>>> vmtruncate,
>>>> but actaully there is no need to call inode_newsize_ok() because
>>>> the checks are
>>>> already done in inode_change_ok() at the begin of the function.
>>>>
>>>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> I didn't receive any feedback from Weinberger, could you consider
>> this patch for next -rc?
>
> Whoops. Sorry. -ENOMAL.
>
> I can carry this patch through uml.git
>
> Thanks,
> //richard
>

No problem, thanks :)

Marco
