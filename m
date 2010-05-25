Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab0EYKf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 06:35:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:46348 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0EYKfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 06:35:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=PkcRsNZRNPWt7jZeT4eS8khMCyzHz1z3b3DEjn5hzM4P/XlYRuKjcB01VioSkYcp2G
         IDV3sN4EK+gKb13RNurEY9YSDrQHUFsJFGAMUqClEChSNTJfU2B3GfJgukWJYpKNf2eq
         041rE+u+N8icsTgpBLX71g05cjDzToJxXNg/s=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frantisek Hanzlik <franta@hanzlici.cz>, linux-kernel@vger.kernel.org
Subject: Re: fs/fs-writeback oopses in kernel 2.6.33.4-95.fc13.i686.PAE
References: <4BFA730C.1010906@hanzlici.cz>
	<20100524230512.8cc7dfc1.akpm@linux-foundation.org>
Date: Tue, 25 May 2010 14:35:20 +0400
In-Reply-To: <20100524230512.8cc7dfc1.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 24 May 2010 23:05:12 -0700")
Message-ID: <87vdacl15j.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 24 May 2010 14:37:32 +0200 Frantisek Hanzlik <franta@hanzlici.cz> wrote:
>
>> Hello,
>> I upgrade from kernel 2.6.33.3 to 2.6.33.4 (2.6.33.4-95.fc13.i686.PAE, 
>> Fedora 13 distro) and now I see several these messages every day in 
>> /var/log/messages:
>> 
>> May 24 14:01:32 ns kernel: ------------[ cut here ]------------
>> May 24 14:01:32 ns kernel: WARNING: at fs/fs-writeback.c:597 
>> writeback_inodes_wb+0x202/0x30e()
>
> I don't see anything which would generate this warning in 2.6.33.4's
> fs/fs-writeback.c:597.  RH must have mucked with it.
Already fixed in mainstream by
commit 7c8a3554c683f512dbcee26faedb42e4c05f12fa
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Tue May 18 14:29:29 2010 +0200

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
