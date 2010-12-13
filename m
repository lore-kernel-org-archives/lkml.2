Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab0LMV7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:59:11 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:50849 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751246Ab0LMV7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:59:10 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18tYFFe+1ktxJz6UqCF6NbCnR1LXEZ68ihV95luuE
	WpZmnHO+TLO5JP
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: [PATCH] checkpatch.pl: ERROR: spaces required
Date: Mon, 13 Dec 2010 22:59:04 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.2; KDE/4.4.5; i686; ; )
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1292263974-15363-1-git-send-email-toralf.foerster@gmx.de> <AANLkTi=oHyk3AF3eKP3Vm2Ywfb9WcgrurNrkYVKfc588@mail.gmail.com>
In-Reply-To: <AANLkTi=oHyk3AF3eKP3Vm2Ywfb9WcgrurNrkYVKfc588@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012132259.05317.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miguel Ojeda wrote at 19:49:43
> 2010/12/13 Toralf Förster <toralf.foerster@gmx.de>:
> > Signed-off-by: Toralf Förster <toralf.foerster@gmx.de>
> > ---
> >  kernel/acct.c |   20 ++++++++++----------
> >  1 files changed, 10 insertions(+), 10 deletions(-)
> > 
...
> > -       if (value==0) return 0;
> > -       while ((s64)value > 0){
> > +       if (value == 0) return 0;
> 
> Newline here. Doesn't checkpatch.pl complain? It is an old rule:
> 
> http://lxr.linux.no/linux+v2.6.36/Documentation/CodingStyle#L60
> 
I'd like to do only one thing at a time - not one file at a time.

-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

