Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab0LOT2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 14:28:08 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:40823 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab0LOT2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 14:28:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HbrEzE3bClXiYQyCItrGMVkRk+8EUoemMoYV6i2vLUi94uZLk4ulwDlNJolj5oVWm5
         ZSNWfL/7ZgCG7z9rg1sAzzVESl5URFm4cNmIcKo7L8kwNrUgV8wUhjCRBc5sGS7JnoVE
         zMdIoox4tLf/nqY3ELIQ+yxKPPuupNSY7SL4w=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=9fbou9YF2bXzrWbBM37F4_Xyi-KgWquq0PrBL@mail.gmail.com>
References: <AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
	<AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
	<20101212023415.GG3059@thunk.org>
	<AANLkTim=i8wDnML+K4uGK_neNDCiWxtKGDx01O+3joaE@mail.gmail.com>
	<AANLkTinhHTqqpP=pQ8Foyc9xeaZi65GHGHGY51OyZtvF@mail.gmail.com>
	<20101212124354.GA4513@thunk.org>
	<AANLkTikZkCs7Wee2=uhe3bw96Pggcv0jsCkZ+nkWEQ+=@mail.gmail.com>
	<20101213020657.GB4513@thunk.org>
	<AANLkTinMWS-yyzWJ3oBo_KS9jXt4p4pveo+SPTLiWnCt@mail.gmail.com>
	<AANLkTimjM_HptLaCSuQivxruWpoc7todyMe0wnszrSYU@mail.gmail.com>
	<20101215191655.GA6163@basil.fritz.box>
	<AANLkTi=9fbou9YF2bXzrWbBM37F4_Xyi-KgWquq0PrBL@mail.gmail.com>
Date: Wed, 15 Dec 2010 20:28:03 +0100
Message-ID: <AANLkTimjnfAQv5J5LRsgtKBb5Ho=M2ZJ=qvDHnkpBwN4@mail.gmail.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
From: Matt <jackdachef@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Jon Nelson <jnelson@jamponi.net>, Chris Mason <chris.mason@oracle.com>,
        Andi Kleen <andi@firstfloor.org>, Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <mbroz@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 8:25 PM, Matt <jackdachef@gmail.com> wrote:
> On Wed, Dec 15, 2010 at 8:16 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>> I have a question though: the deactivation of multiple page-io
>>> submission support most likely only would affect bigger systems or
>>> also desktop systems (like mine) ?
>>
>> I think this is not a final fix, just a workaround.
>> The problem with the other path still really needs to be tracked down.
>>
>> -Andi
>>
>> --
>> ak@linux.intel.com -- Speaking for myself only.
>>
>
> ok,
>
> thanks for the clarification
>
> Regards
>
> Matt
>

Sorry to spam the mailing lists again

make that a
Reported-and-Tested-by: Matthias Bayer <jackdachef@gmail.com>

(hope that's the correct way to write it)

Regards

Matt
