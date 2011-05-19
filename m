Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686Ab1ESRUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:20:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:34028 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933593Ab1ESRUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:20:53 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/Of2BJLjLOm1Uxn43CaFWXDIQT7PQ4rqOLb7cs4C
	9hvlme4dO8tULy
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: "richard -rw- weinberger" <richard.weinberger@gmail.com>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
Date: Thu, 19 May 2011 19:20:44 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6; KDE/4.6.3; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
References: <201105191526.31904.toralf.foerster@gmx.de> <BANLkTi=FinuAYpYXf1K6pQ-3i2vRJS=g9g@mail.gmail.com>
In-Reply-To: <BANLkTi=FinuAYpYXf1K6pQ-3i2vRJS=g9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105191920.44596.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


richard -rw- weinberger wrote at 19:00:35
> Hi,
> 
> Please CC also user-mode-linux-devel@lists.sourceforge.net,
> so you can reach much more UML users. :)
> 
> 2011/5/19 Toralf Förster <toralf.foerster@gmx.de>:
> > I got a segfault as soon as I try to access the phpmyadmin web page of
> > the UML
> 
> > instance at https://<uml_hostname>/phpmyadmin/  :
> Hmm, strange.
> phpmyadmin works fine on my UML test bed.
> Can you bisect the issue?

Errm, automatic bisecting doesn't work, b/c the issue can't be reproduced by a 
simple "wget https://..." - when I use konqueror - up to 6-10 times I'm asked 
to confirm a cookie or something else before the crash occures.

And if I use "lynx -accept_all_cookies https://n22_uml/phpmyadmin/" then I'm 
able to login - so it has something to do with HTTP frames I suspected - but a 
shutdown of the UML instance wasn't possible too after such a try - probably 
something else then the HTTP frames itself triggers the issue ...

In short -  it is not phpmyadmin (3.4.0) itself, but it triggers the bug (in 
fact sometimes I even could see the login window within Firefox of the 
phpmyadmin site before the crash happened).

Because therefore manual interaction is needed (or do you know an automated 
way for konqueror/ff/.... ?) at least it would be helpful if the bisecting 
could be narrowed doesn to a given path or somethign else.

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
