Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0ICCpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 22:45:33 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54768 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab0ICCpc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 22:45:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uwiJ6y9LD3Wa9O9QgvWeUR1Ac/udfykqZ+8kTNI1lwoXPd+0dvkCTV6jLvTrA4AQNR
         JY+o/uQTzbr5YCFSJyHyQRbqjHjMhMTpjsv5tRslRj8tgDCTnUGz9xvpolPzIDZoHFbu
         pKzkgbmGcxA7HSwf+ydoI0FCv3cVaR4L8qB+8=
MIME-Version: 1.0
In-Reply-To: <AANLkTikBOUSGYkopdUcV+5KsayRi-_88kktMLv=KXRU0@mail.gmail.com>
References: <AANLkTi=Y7RmojC2+1Zdw0jeGm99Gj7anVqReJkrgDmRg@mail.gmail.com>
 <20100902121853.e90f6c53.randy.dunlap@oracle.com> <AANLkTinehv75C+xhsDA_7HHoT9m_BkmL1aE_oyM9BJO4@mail.gmail.com>
 <AANLkTikBOUSGYkopdUcV+5KsayRi-_88kktMLv=KXRU0@mail.gmail.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Thu, 2 Sep 2010 23:45:12 -0300
Message-ID: <AANLkTin9cX5S1ToK=2yFN5TsqH25aN2fFoCdvSizqOH9@mail.gmail.com>
Subject: Re: [RFC] Fix typos
To: Phillip Lougher <phil.lougher@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 23:29, Phillip Lougher <phil.lougher@gmail.com> wrote:
> On Thu, Sep 2, 2010 at 8:31 PM, Lucas De Marchi
> <lucas.de.marchi@gmail.com> wrote:
>> On Thu, Sep 2, 2010 at 16:18, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
>>> I'm not so sure about "is rose up" being better.  and what about "ar"?
>>
>> I'm only changing words with 3 chars or more, because otherwise I
>> would have a lot of false positives, but I think I can add this word
>> without much trouble.
>>
>
> The problem with "ar" is it is too short to know for certain what it
> should be...  "ar" though likely a typo for "are" could also be a typo
> for e.g. "arm", "arc", "arg", "ark", and "arp".
>
> Perhaps in this and similar cases the script should flag these errors
> for human attention rather than automatically fixing them.

Yes, after enabling it I've saw a lot of false positives and wrong
fixes. Even cases where "ar" was the correct one, referring to the ar
tool.

Now, I put this together with other warnings.



-- 

Lucas De Marchi
