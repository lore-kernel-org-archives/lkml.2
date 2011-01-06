Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab1AFL4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 06:56:00 -0500
Received: from nm22-vm1.bullet.mail.sp2.yahoo.com ([98.139.91.223]:26705 "HELO
	nm22-vm1.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752817Ab1AFLz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 06:55:58 -0500
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 663234.57812.bm@omp1038.mail.sp2.yahoo.com
Message-ID: <376869.1852.qm@web113303.mail.gq1.yahoo.com>
X-YMail-OSG: _e2XAxgVM1mqM0YDDMDN5SQKqsuv24wAiVVPNb5nFWCR5DW
 u2tnPLGmT8vuZk4m79HQCkHW1gFKRHBqn.KXL541jxZkeK2Q3Cy_X6XbhEwS
 dSQ3hYdzhkUjusPJp3B7smHIEF3M41MmEr073vN3oBv7GUc.jAD7VMkI6AOg
 e2xyjuGhR3rroB8lLDF1ZUtI.nWZtm8NrYNRjmQN8CGi6qqdcHT6FXMziBBb
 Q_rjywGxHCqCJChQsE89_rV2lG0hbpI2ZDjeAIOw9Th5FlkLZGwHF.0xJWdo
 h_vlQ_Mp44vDEmt_AwIjjud0p1Io0r2mJtmjRO_ACgU6Jkix4A9v0Lw3NyrF
 bqLDZVYsXgWwSwPNt3o.tIShV4F4_NzC4frN19ey9KlO8NzGO7JCS
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/553 YahooMailWebService/0.8.107.285259
References: <20110104055900.GA5062@bicker> <20110104163836.GA30317@fieldses.org> <20110104164414.GX5875@const.bordeaux.inria.fr> <1294160834.6617.51.camel@Joe-Laptop> <m3fwt7i740.fsf@intrepid.localdomain>
Date: Thu, 6 Jan 2011 03:55:56 -0800 (PST)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: [patch] checkpatch: putting the && or || on the wrong line
To: Krzysztof Halasa <khc@pm.waw.pl>, Joe Perches <joe@perches.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Dan Carpenter <error27@gmail.com>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <m3fwt7i740.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Krzysztof Halasa <khc@pm.waw.pl>
> To: Joe Perches <joe@perches.com>
> Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>; J. Bruce Fields 
><bfields@fieldses.org>; Dan Carpenter <error27@gmail.com>; Andy Whitcroft 
><apw@canonical.com>; linux-kernel@vger.kernel.org; 
>kernel-janitors@vger.kernel.org
> Sent: Wed, January 5, 2011 6:38:07 PM
> Subject: Re: [patch] checkpatch: putting the && or || on the wrong line
> 
> Joe Perches <joe@perches.com> writes:
> 
> > As do  I, but perhaps coding style in a project like this
> > shouldn't be personal  but collective.
> 
> I think there is nothing like a collective style.
> What  you can eventually achieve is a style everybody hates.
> 
> > The trailing  style outnumbers the leading style ~ 5:1.
> >
> > $ grep -rP  --include=*.[ch] "(\|\||&&)[ \t]*$" * | wc -l
> > 39890
> > $  grep -rP --include=*.[ch] "^[ \t]*(\|\||&&)" * | wc -l
> >  8244
> >
> > If you take out drivers/staging, trailing is used ~  6:1.
> >
> > I think that high enough to be declared the preferred  style.

 Nobody defines which style *I* prefer. One (in this case the compiler) may 
define which laws I obey, but not which style I like. As long as the compiler 
accepts both notations and generates the same code there is no "law" against 
either.

> 
> This is a very weak reason (if any at all) to do so. Increasing  e.g.

 indeed.

> readability of the code would be a good reason, but  statistics?
> 

 But who is defining readability? That is not a technical term at all. What I 
view as readable may completely from your or Joes or anybody elses opinion.

> Maybe: Microsoft Windows outnumbers Linux X:1, so it should  be declared
> the "preferred" system (= the only allowed, as with CodingStyle  and
> checkpatch "errors").
> 
> Or: cars outnumber trucks X:1, declare the  trucks illegal.

 I would really think about supporting that :-)

> Coffee drinkers outnumber tee drinkers, kill the  later.
>

 Here I am for personal freedom :-)
 
> 
> Yes, we need some basic common style (tabs length,  unless/until we can
> use any tab length), K&R (or other) parentheses, void  *var instead of
> void* var (void* var1, var2 bugs), (no) spaces etc. Anything  less make

 Actually if this allows ambigous code, the language has a problem. But yeah, a 
tool to enforce one way is good.

> the code unreadable or less readable. We should stop dictating  the
> details when the benefits end, and they end pretty fast.

 Amen.

Cheers
Martin

