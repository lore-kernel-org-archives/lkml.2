Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab0FWJvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 05:51:48 -0400
Received: from n4.bullet.mail.gq1.yahoo.com ([67.195.9.84]:41280 "HELO
	n4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750967Ab0FWJvr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 05:51:47 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 819217.14813.bm@omp128.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=QtWb5pKy+JkSy+SlvEftiZN9Ytq/+mo/ktgA0wJ97GNliGvQ0k+5ewBj5osw+eBq6/Gu03AaQ41ez/Jp3XyTECFUE9677lZxs6RS6scJykDaC3palLG3V8WY1QIRenqDZpohqx2YKC1g0ojRfwOjr67GmcZsjwlKM9u2MMUfVGU=;
Message-ID: <711634.79166.qm@web180314.mail.gq1.yahoo.com>
X-YMail-OSG: mFAuyGgVM1m9w.SjVc5uLTgK7s5IRCUFagnc6w5Zs1ta3TY
 rIAhjBGlgIAenk7wCXIbkfEEB5_n7XtZW4COhFJK2EjQPD5CiL67egcYHVMF
 DJ.zNZZ6M4HuG7ygKyDH.hSaxIn43Ytg3ixtphorM95MKU6Xm8iM8zQcDa9b
 LE9SA2tgmPC2FVF5sjJPOSNRZGRbUpYIL41ZiuQc9x79j2BjM6ivIkyIYaVo
 33oUOdK2TZmc7n5j2a858YzZMPanu5YCZs7zo0Uz1UmsVVx8VhETdcrCGaxc
 F_Jxu2yG085.kNXWCUQ--
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.104.274457
Date: Wed, 23 Jun 2010 02:51:46 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and sleeping  gpios)
To: Eric Miao <eric.y.miao@gmail.com>
Cc: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Ryan Mallon <ryan@bluewatersys.com>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <AANLkTinuO053upBHzsiQ2llNdu4_XZN0rfz01QuIE7LW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >
> > So, NAK on these proposed changes.
> >
> 
> Hi David,
> 
> You are really a NAKing machine ;-)

I limit NAKs to bad ideas/code, like this.


 People get confused for
> a reason, and
> I believe you have a good solution  for this?


Ryan seems to need a cluebat application.  I've
tried, but he's resisted, and even denied the most
blatant sources of his personal confusion.  While
he esists, I can't do much. for him.


