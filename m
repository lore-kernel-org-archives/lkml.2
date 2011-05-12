Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab1ELKEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 06:04:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43239 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab1ELKEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 06:04:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZNEQ4UX9a+zNqPdIKZQA2HLcQy6XLQijXWHkgEIBMP8Of6QxdaCuqz3c2BmtjmqsLl
         qviX1Cco67Hj54gGC7WIZIJ+KMpk4QmQctX8Xmwiv6K9GfAklSTEKWX4JXuFoa7JfuI+
         jSvB042PSRQ534ivIs8kxoLhzDiKTx2ewBkfw=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
References: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
	<BANLkTim-FmuENeU_Cai+nYnTP+uJTEn3PA@mail.gmail.com>
	<BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
Date: Thu, 12 May 2011 18:04:51 +0800
Message-ID: <BANLkTim0OGhBV4Ut81C3twKOBBjxUnkczQ@mail.gmail.com>
Subject: Re: problem with kmemleak
From: ttlxzz ccc <boyzccc@gmail.com>
To: Maxin B John <maxin.john@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am chenxi, too :)

On Thu, May 12, 2011 at 5:44 PM, Maxin B John <maxin.john@gmail.com> wrote:
> Hi,
>
> Could you please share some more information about your setup ?
>
> Regards,
> Maxin
>
> On Thu, May 12, 2011 at 4:13 AM, ttlxzz ccc <boyzccc@gmail.com> wrote:
>> help~~~：） please ！thx！！
>>
>> On Thu, May 12, 2011 at 10:06 AM, ttlxzz ccc <boyzccc@gmail.com> wrote:
>>> Hi, all:
>>>
>>>
>>>
>>> I just want to use kmemleak, so I make the CONFIG_DEBUG_KMEMLEAK and
>>> CONFIG_DEBUG_FS on, mount the debugfs.
>>>
>>> But when I insmod mm/kmemleak-test.ko, echo scan >
>>> /sys/kernel/debug/kmemleak and cat /sys/kernel/debug/kmemleak. I just
>>> see this:
>>>
>>> unreferenced object 0xffffc90012d21000 (size 64):
>>>
>>>  comm "insmod", pid 13092, jiffies 4298369684
>>>
>>>  hex dump (first 32 bytes):
>>>
>>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>
>>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>
>>>  backtrace:
>>>
>>>    [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>> unreferenced object 0xffffc90012d24000 (size 64):
>>>
>>>  comm "insmod", pid 13092, jiffies 4298369684
>>>
>>>  hex dump (first 32 bytes):
>>>
>>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>
>>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>
>>>  backtrace:
>>>
>>>    [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>> unreferenced object 0xffffc90012d27000 (size 64):
>>>
>>>  comm "insmod", pid 13092, jiffies 4298369684
>>>
>>>  hex dump (first 32 bytes):
>>>
>>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>
>>>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>
>>>  backtrace:
>>>
>>>    [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>> There is no other backtrace except [<ffffffffffffffff>]
>>> 0xffffffffffffffff. Then I read the mm/kmemleak.c. In
>>> kmemleak_seq_show(), I find that the object->trace_len is 1.
>>>
>>>
>>>
>>> How can I get the full backtrace?
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
