Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab0JVQwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:52:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42152 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab0JVQwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:52:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=oJnNfLnvbW9ZCoFNBF1StaWKyGKGvB73XFf6oanxwHkJoyKBjiXYqOQ7XQLgnlGnmy
         NBXLJb1idUW4AZil/fKiQi/HiwJnfqCWa7DMIMWzyCPWuEmlpxRi6ZkwtZtYyuE/6FCG
         20WTmZyTBFFu3c9+m2Imxmav/JmxGDEKeogAI=
MIME-Version: 1.0
In-Reply-To: <4CC190D2.6070305@sapience.com>
References: <5600814.270321287742009359.JavaMail.root@mail-zbox20.bo3.lycos.com>
 <30241116.270781287743584802.JavaMail.root@mail-zbox20.bo3.lycos.com>
 <AANLkTin6rvckZ3q9xY8Chzc1iDvkV1ObTP42n9Ye943Y@mail.gmail.com> <4CC190D2.6070305@sapience.com>
From: kevin granade <kevin.granade@gmail.com>
Date: Fri, 22 Oct 2010 11:51:31 -0500
Message-ID: <AANLkTikyyDuMemndfezEijTHHW6798+yQO_FmLyjyPTV@mail.gmail.com>
Subject: Re: On Linux numbering scheme
To: Genes MailLists <lists@sapience.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 8:25 AM, Genes MailLists <lists@sapience.com> wrote:
> On 10/22/2010 06:41 AM, Alexey Dobriyan wrote:
>> On Fri, Oct 22, 2010 at 1:33 PM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
>>> What can you say about kernel 2.6.32? Almost nothing.
>>>
>>> What can you say about kernel 3.11.3? - it is the third release of
>>> Linux in 2011.
>>
>> And? What a useless information.
>>
>> BTW, it should be 3.2011.3, see Y2K.
>> --
>
>   If you -really- wanna go that route - may as well be
>
>      20.11.3.18

I think the reason day was excluded by previous suggestions is that
the current development model doesn't generate a "blessed" version on
anything close to a daily rate.  Even if you wanted to incorporate the
-rcs or -next into this scheme, it seems like it'd be somewhat
problematic since the day field would drop in value during development
e.g.
20.11.3.18 = 2.6.37-rc1
20.11.3.25 = 2.6.37-rc2
20.11.4.2  = 2.6.36-rc3

That having been said, <century>.<year>.<month> would be as valid as
3.<year>.<month>, and might help drive home the point that the version
number is "a point in development" rather than some kind of "indicator
of feature releases".

>
>    century.decade.month.day .. that way we don't have problem until we
> hit the year 10,000 ... :-)

Or until the New Galactic Calendar is introduced... ;)

Silliness aside, what are the deficiencies of the current numbering
that are being addressed here?  The only things I can come up with
are, "major number is getting too big" and "development no longer
follows a major/minor feature based model, so the version numbering
scheme should reflect this".  Are there any other reasons for a
change?

Kevin

>
>
>  g
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
