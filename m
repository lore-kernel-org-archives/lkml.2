Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab1FBADp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 20:03:45 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:39308 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416Ab1FBADn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 20:03:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XGXq+wp0pt5ahJJvJcvuNpt8NV+lNUnL3XCsT3d0Lb3Fx/vB9KU7rh3cAaz1B30aRC
         uySm+s5qxmyns8k+hEnh4I9oG5EIzfAb4+Hx8QygXGSC08eagsuPr+8imQJVExyoH4Ub
         mKPLHQK9hTWzaZM+dMedB5bWez8mEVwOQKykA=
MIME-Version: 1.0
In-Reply-To: <1306950434.3627.23.camel@ayu>
References: <BANLkTikvU-XUu9sWX-E87a7CUtA7j+ZRpA@mail.gmail.com>
	<BANLkTi=w7VhV2GxKrGGe9dirHcEkwKrDwA@mail.gmail.com>
	<BANLkTim7XZKLCRp=ZtRJWhi7k4BzwYpRpg@mail.gmail.com>
	<20110531201348.GA8723@1wt.eu>
	<1306950434.3627.23.camel@ayu>
Date: Wed, 1 Jun 2011 20:03:41 -0400
Message-ID: <BANLkTim7mGXzRhvnziyLBSULGYg2N+L0BA@mail.gmail.com>
Subject: Re: Linux 3.0 change listings - Wonderful World of Linux 3.0
From: Joe Pranevich <jpranevich@gmail.com>
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: Willy Tarreau <w@1wt.eu>, Mike Frysinger <vapier.adi@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thank you for the feedback. While I already have a section about what
v3 means right at the top, I will be reworking the exuberance out of
the finished text, cutting the use of the word "new", and making it
more clear that this is a "v2.6 retrospective", to use your term. I
will also place notices to that effect on each page of the web version
of the doc. I think I have done a reasonable job in summarizing where
Linux has moved to since the last "dot-zero" release, which was my
hope and intent, and now I just want to move the text to make that
more clear.

This has been a good experience. I regularly follow kernel development
and read change logs, but there were still numerous things that I
learned about Linux 2.6.x that I didn't know. The wide angle lens
helped me and I hope it can help others. (My inclination, if I do this
again, would be to do a yearly writeup (WWOL 2012), though perhaps
we'll have yearly point releases anyway.)

I will finish these changes by Sunday. The doc may be too long for
another kernel post, but I appreciate the corrections and feedback so
please keep them coming.

Joe


On Wed, Jun 1, 2011 at 1:47 PM, Calvin Walton <calvin.walton@kepstin.ca> wrote:
> On Tue, 2011-05-31 at 22:13 +0200, Willy Tarreau wrote:
>> On Tue, May 31, 2011 at 01:22:49AM -0400, Joe Pranevich wrote:
>> > Mike,
>> >
>> > Thank you. I appreciate the comments and the corrections. It was a
>> > marathon weekend and yes, I missed some obvious typos. Thanks.
>> >
>> I'd say that in general, almost all of the features you're announcing as
>> "new" will make unaware people think that older versions did not have
>> those features, which is quite misleading. Linus took great care to say
>> that 3.0-rc1 had very few changes, it can be a bit confusing to see a
>> post pretending it to be a revolutionary new kernel.
>>
>> Probably that you should more clearly say that all those features were
>> progressively added in all 2.6 releases, otherwise I'm already expecting
>> to see a lot of idiocies posted in journals.
>
> Perhaps a simple change of the title and introduction would handle
> clearing this up. Instead of presenting it as a "What's new in Linux
> 3.0" article (which it is not, or it would be a lot shorter!), why not
> call it what it actually is: "A Retrospective of the Linux 2.6 era"?
>
> --
> Calvin Walton <calvin.walton@kepstin.ca>
>
>
