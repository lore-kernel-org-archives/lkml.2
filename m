Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab1EXVSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:18:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36090 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab1EXVSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:18:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=jnayn5VCH3dWooM0BWmHyVt46U74BXzCoQxzBDMFV9dMucDyqewSlkLIO/Yyw4r0Ib
         L+6xl8nkQntTZh5sHncFy/tU4tZ6WEKRY0zcVugXUpJL/SEeYRdkEakAw02QyFkNkerN
         Of70iXdK3SoeQ+F9O96RIe0ke5QpHSf+bCUgA=
MIME-Version: 1.0
In-Reply-To: <4DDBFC30.6030201@fusionio.com>
References: <4DDBF40E.7020003@fusionio.com> <BANLkTi=sYVpvEwShbhC65qfaA0Jt3rEjsQ@mail.gmail.com>
 <4DDBFC30.6030201@fusionio.com>
From: Mike Snitzer <snitzer@redhat.com>
Date: Tue, 24 May 2011 17:17:42 -0400
X-Google-Sender-Auth: V6_INo2eSeFrVzVUfut8cWbTnPs
Message-ID: <BANLkTimLL0QgNzQrpvGSxng0boOWZQbBiQ@mail.gmail.com>
Subject: Re: [GIT PULL] Start of removal of legacy parallel interfaces for 3.0
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 2:42 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-05-24 20:37, Linus Torvalds wrote:
>> On Tue, May 24, 2011 at 11:08 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>>
>>> With the 3.0 kernel approaching, now is a great time to get rid of some
>>> legacy bagage. And what better part to start with than the old IDE code.
>>> Parallel interfaces are so 1990's, we can't be seen with those on a
>>> fancy new kernel version.
>>
>> No.
>>
>> Guys. Really.
>>
>> Any version numbering change is *not* an excuse to drop any old stuff,
>> or do anything new and exciting.
>
> Boy, you guys sure are humorless. I would've thought the reference to
> killing SCSI next would be a good clue.

If you also referenced "42" everyone would've been in tears.. ;)
