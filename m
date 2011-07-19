Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab1GSV0C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 17:26:02 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20171 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab1GSV0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 17:26:00 -0400
Date: Tue, 19 Jul 2011 23:25:57 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Michael Krufky <mkrufky@kernellabs.com>
cc: linux-media@vger.kernel.org, Mike Isely <isely@pobox.com>,
        Aurelien Alleaume <slts@free.fr>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: Hauppauge model 73219 rev D1F5 tuner doesn't detect signal,
 older rev D1E9 works
In-Reply-To: <CAOcJUbz9ZeUHOzkgVfktwJ4vH9+HOP3=EfVP2xbaYhB49Gcbug@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1107192324450.7578@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107151455140.28453@swampdragon.chaosbits.net> <CAOcJUbz9ZeUHOzkgVfktwJ4vH9+HOP3=EfVP2xbaYhB49Gcbug@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-505859297-1311110758=:7578"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-505859297-1311110758=:7578
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 19 Jul 2011, Michael Krufky wrote:

> On Tue, Jul 19, 2011 at 3:37 AM, Jesper Juhl <jj@chaosbits.net> wrote:
...
> > I can test any patches you may come up with and if there's any further
> > information you need from me in order to get an idea about what the
> > problem is, then just ask.
> >
> > Please CC me on replies since I'm not subscribed to the linux-media list.
> >
> > --
> > Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> > Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> > Plain text mails only, please.
> >
> 
> I have a suspicion as per the cause of this problem...  Would you care
> to try a patch to see if it fixes the problem?  (note:  this should
> not be merged, as it is not an actual fix -- simply an test to show us
> how to arrive at the appropriate fix)
> 
Thank you Michael. I'll try this patch tomorrow when I have access to my 
test hardware. I'll get back to you with results ASAP.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-505859297-1311110758=:7578--
