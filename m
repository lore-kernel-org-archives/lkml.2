Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab0H1SLL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 14:11:11 -0400
Received: from n3c.bullet.mail.ac4.yahoo.com ([76.13.13.80]:26111 "HELO
	n3c.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753312Ab0H1SLJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 14:11:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 247962.34683.bm@omp123.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=t+9JOzVFJNEkGLD8a6WzAuAfp0YblgxxZo293+mgnYeubEt3IB2K/0ajrU3fcU2GA/cPT3vk/UlyvB2g9JH32nxGmz1L3vrkSM45OeFPn8ye2NYjVi+W6mqX/kZWwP2dmlzpe6Tr8gYW1vqPgvPRF+13V0tkmnKUAZvJH0CQKNw=;
Message-ID: <620873.86430.qm@web180307.mail.gq1.yahoo.com>
X-YMail-OSG: fwrL2OMVM1nLK9Rmpo0QGR.a7Zq_cRBP_ehnBYcmSZ3ZNmG
 7wEvvxB_rhW0EHPNiBgUD4gCduGAA44vs5LNKUjnHKUZzDvn.JgrSlmjUIp_
 sPawQYVYb8HktjFXsDuCueyLIlRtXFf3jI7RNP.WbPO0QK1eCSrMjhSBefj3
 ohjrbwt41iWQkCwssPUs74DBXuz_q6mOmsjjAqyQ7A9UOX9HuQSdrgF9Bx4v
 ePSj.1j_kLss9TJbt4wChJkiVwP6Jzr1PJWTm.PasV6S9HFCjU9ShQ4tk55u
 dSbno_GZIqNr2F22yj1IygsbJbyYR6Gl.8292Ca8ARGaZfQTr9_nMsTwC3qw
 ZSnt4CbRLhf8-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sat, 28 Aug 2010 11:11:07 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 2/7] drivers/usb/gadget: Remove double test
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, Julia Lawall <julia@diku.dk>
Cc: Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        kernel-janitors@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-geode@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1008281916580.13508@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sat, 8/28/10, Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> Subject: Re: [PATCH 2/7] drivers/usb/gadget: Remove double test
> To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
> Cc: "David Brownell" <david-b@pacbell.net>, "Thomas Dahlmann" <dahlmann.thomas@arcor.de>, kernel-janitors@vger.kernel.org, "David Brownell" <dbrownell@users.sourceforge.net>, "Greg Kroah-Hartman" <gregkh@suse.de>, linux-geode@lists.infradead.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Saturday, August 28, 2010, 10:17 AM
> On Sat, 28 Aug 2010, Stefan Richter
> wrote:
> 
> > Julia Lawall wrote:
> > > On Sat, 28 Aug 2010, David Brownell wrote:
> > > 
> > >> Please update $SUBJECT to say which driver
> is
> > >> affected;
> > > 
> > > Done.

Thanks.  Unless the author/maintainer of this
driver objects, the patch is OK by me.


> > > 
> > >> it's not everything in that directory,
> > >> and accurate GIT summaries help a lot.
> > > 
> > > Is there some sort of rule that can be
> followed? 

Don't be misleading ...

Generally, if it updates just one driver,
mention that driver in $SUBJECT.

Only say the subsystem itself is being
updated (which your original $SUBJECT did)
when the patch affects framework code, 
that's shared by all drivers, 

 > > >  What if the 
> > > patch affects only two files?

Which two files?
The "patch updates one thing" rule will then
cause it to affect only one driver (usually)
or some framework issue, so the above policies
kick in directly.

Rarely there will be bugs repeated (e.g. via
cut/paste) in multiple drivers, ... in which
 case  it can make sense to summarize a patch
as a multi-driver subsystem fix .  Similarly
with API changes.




