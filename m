Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab1AND64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:58:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49072 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab1AND6x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:58:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=jhgphn/35/kBarCsjzNUWA7skXnUuiS0GoLoC1H0uKz37Qj7IdTGB5jrDaPfIwwi4B
         C596dHxUzeEIQimKjBFS1M6vjaj4MOYc2YHRk48mRRIrYACm+he/Pr0rwloS6mxwtD30
         PeI0WJbZ22S8C1XqrFcr6PBoDf7PcwxXIp9sw=
MIME-Version: 1.0
In-Reply-To: <AANLkTimjRYref7+7LS7Su=THo6JFBRV0uEyaWwGqeAXT@mail.gmail.com>
References: <AANLkTi=3UmR6=L-bKSJ2SbioPjaHodgzTj4my9dbNP1L@mail.gmail.com>
	<AANLkTimjRYref7+7LS7Su=THo6JFBRV0uEyaWwGqeAXT@mail.gmail.com>
Date: Fri, 14 Jan 2011 14:58:52 +1100
Message-ID: <AANLkTimrZnsN+dasGk1R4vmRR=VJ0pDcHvY-eary8hGx@mail.gmail.com>
Subject: Re: Please pull vfs-scale-working tree
From: Nick Piggin <npiggin@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 2:41 PM, Nick Piggin <npiggin@gmail.com> wrote:
> On Fri, Jan 14, 2011 at 2:24 PM, Nick Piggin <npiggin@gmail.com> wrote:
>> Git tree is here:
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
>>
>> Branch is:
>>
>>    vfs-scale-working
>>
>> Head:
>> 657e94b673a805b427903c5628e95348235fad06
>>
>> Diffstat:
>>  Documentation/filesystems/porting |    8 ++++----
>>  Documentation/filesystems/vfs.txt |    4 ++--
>>  fs/namei.c                        |   18 ++++++++++++++++++
>>  fs/nfs/dir.c                      |    6 +++++-
>>  include/linux/list_bl.h           |    5 +++--
>>  include/linux/rculist_bl.h        |    3 ++-
>>  6 files changed, 34 insertions(+), 10 deletions(-)

Sorry, one more, I missed one of J. R. Okajima's review patches

Head is:
f20877d94a74557b7c28b4ed8920d834c31e0ea5
