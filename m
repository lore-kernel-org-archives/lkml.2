Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab0IBUYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:24:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42556 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0IBUYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eaSCyxfrx6vg7cYFDANsJMRtsw08XKvwqsdhwPudn6r7nt2D4iIY9H5SkGvLA4/gZe
         4NcHldZ5710gCoAgkjoGRa8+zCVszvsdWisbFD0dX/8gd25wgCskb9DDMjAkYuV0XgSm
         Z9/jrNJzYMS3t7WuWr5lzkzWhbyInswCe/LyI=
MIME-Version: 1.0
In-Reply-To: <AANLkTinz2TEgJD5XVXSgcN0Zq0cL43a9xh004etmA2=V@mail.gmail.com>
References: <AANLkTi=Y7RmojC2+1Zdw0jeGm99Gj7anVqReJkrgDmRg@mail.gmail.com>
 <20100902121853.e90f6c53.randy.dunlap@oracle.com> <AANLkTinehv75C+xhsDA_7HHoT9m_BkmL1aE_oyM9BJO4@mail.gmail.com>
 <4C800266.1000005@oracle.com> <AANLkTineHC5C=Sv5uZezx7-RF3_rQOJFBePhfzD6jfMF@mail.gmail.com>
 <AANLkTinz2TEgJD5XVXSgcN0Zq0cL43a9xh004etmA2=V@mail.gmail.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Thu, 2 Sep 2010 17:23:16 -0300
Message-ID: <AANLkTinnc3rd6EQNAJB_37QAP0qSuxoqvZQVXS0ifUm7@mail.gmail.com>
Subject: Re: [RFC] Fix typos
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 17:16, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Thu, Sep 2, 2010 at 16:08, Lucas De Marchi wrote:
>> On Thu, Sep 2, 2010 at 17:00, Randy Dunlap wrote:
>>> It looks good for Documentation/.
>>>
>>> And fixing typos is certainly something that we want to do in
>>> user-visible messages, like printk strings.
>>
>> What about comments and code?
>
> i think it's useful to fix typos in those things, but this would def
> require a human to review things.  it might also be saner to start

I agree. This is me :-)

> with a whitelist of common typos (doesnt checkpatch have this ?)
> rather than doing it against a dictionary.

I'm running a script with a dictionary of common typos, not a "normal
dictionary".

> for example, we've committed a few drivers that used "platfrom" in
> their structure names when it should have been "platform".

I didn't have this typo, but I can add it as well.


-- 

Lucas De Marchi
