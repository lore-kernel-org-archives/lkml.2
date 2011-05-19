Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab1ESRZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:25:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37213 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933494Ab1ESRZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:25:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=puzgegY5b6FLRNf2zEzA466JTm55kUDSZWpiPti9lTDi/oZAireMc8aqh6nFikI7Qz
         oFefy6zetGGmx11HBgIMXFCcHMu903n0S9FcfobEmMWWBMOKbO33CbVLqQWADb9nmkjq
         OtZSOyAJH32f9oi0h4gXeMF5+Z/vKrySJnV08=
MIME-Version: 1.0
In-Reply-To: <201105191920.44596.toralf.foerster@gmx.de>
References: <201105191526.31904.toralf.foerster@gmx.de>
	<BANLkTi=FinuAYpYXf1K6pQ-3i2vRJS=g9g@mail.gmail.com>
	<201105191920.44596.toralf.foerster@gmx.de>
Date: Thu, 19 May 2011 19:25:52 +0200
Message-ID: <BANLkTi=kDHuhKyVxEYWL92pyfLuQWAjtdQ@mail.gmail.com>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/19 Toralf Förster <toralf.foerster@gmx.de>:
> Errm, automatic bisecting doesn't work, b/c the issue can't be reproduced by a
> simple "wget https://..." - when I use konqueror - up to 6-10 times I'm asked
> to confirm a cookie or something else before the crash occures.
>
> And if I use "lynx -accept_all_cookies https://n22_uml/phpmyadmin/" then I'm
> able to login - so it has something to do with HTTP frames I suspected - but a
> shutdown of the UML instance wasn't possible too after such a try - probably
> something else then the HTTP frames itself triggers the issue ...
>
> In short -  it is not phpmyadmin (3.4.0) itself, but it triggers the bug (in
> fact sometimes I even could see the login window within Firefox of the
> phpmyadmin site before the crash happened).
>
> Because therefore manual interaction is needed (or do you know an automated
> way for konqueror/ff/.... ?) at least it would be helpful if the bisecting
> could be narrowed doesn to a given path or somethign else.

BTW: Haven’t you had such an issue a few months ago?
Does it work without https? Maybe mod_ssl triggers the bug...

-- 
Thanks,
//richard
