Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab2KFHhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 02:37:06 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56563 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab2KFHhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 02:37:05 -0500
MIME-Version: 1.0
In-Reply-To: <87ehkf6jxs.fsf@devron.myhome.or.jp>
References: <20121030134449.GA5435@redhat.com>
	<1351632646.1339.72.camel@x61.thuisdomein>
	<87y5in8nys.fsf@devron.myhome.or.jp>
	<1351676454.1339.99.camel@x61.thuisdomein>
	<87ehkf6jxs.fsf@devron.myhome.or.jp>
Date: Tue, 6 Nov 2012 16:37:03 +0900
Message-ID: <CAKYAXd_m-Vi=oEitg2JpK5MfiBYkL3KbRyQG2mV9--vNUTxaEw@mail.gmail.com>
Subject: Re: NULL pointer dereference at fat_detach
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Paul Bolle <pebolle@tiscali.nl>, Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@parisplace.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/31, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Paul Bolle <pebolle@tiscali.nl> writes:
>
>> On Wed, 2012-10-31 at 09:49 +0900, OGAWA Hirofumi wrote:
>>> This bug is known as the inotify bug. I recall I talked about this,
>>> maybe years ago.
>>
>> Would that be this thread: https://lkml.org/lkml/2011/6/10/155 ?
>
> Sure, exactly.

I found related patch.
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=fe9b25d3ee6bdf6f9c9a9ce61d9d3e144bac13ef

Maybe the above patch should be applied to fix this issue in stable kernel.
Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
