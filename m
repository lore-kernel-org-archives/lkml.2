Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068Ab2FAIla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 04:41:30 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44231 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811Ab2FAIl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 04:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120531201502.GA30000@ZenIV.linux.org.uk>
References: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
 <20120516143830.GA483@kroah.com> <alpine.LNX.2.00.1205161640520.8796@pobox.suse.cz>
 <CAFU-uVt94sgzq7DgsgKL2OJ0e7DazvNpFunx7BNEz88LHJOg+g@mail.gmail.com>
 <20120516150813.GA3293@kroah.com> <CAFU-uVvzyN0asmReOVJcAEiAtbQ=styfGxRRbnrJKgNFDS5X_g@mail.gmail.com>
 <CAFU-uVsStG0KoiQm95-uC8ZPXWAq=8Q8vXircxOuUCHhk+r9uw@mail.gmail.com>
 <1338492342.5861.23.camel@joe2Laptop> <20120531201502.GA30000@ZenIV.linux.org.uk>
From: Philipp Riemer <ruderphilipp@gmail.com>
Date: Fri, 1 Jun 2012 10:41:06 +0200
Message-ID: <CAFU-uVupiK5O-LC=wA3Tte78hjzwSJSwUGLb2-58VJSs5z0_hQ@mail.gmail.com>
Subject: Re: [GIT PULL] new mailmap file for the linux kernel git repository
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joe Perches <joe@perches.com>, Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Paul Mundt <lethal@linux-sh.org>,
        =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Wang Chen <ellre923@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/31 Al Viro <viro@zeniv.linux.org.uk>:
> On Thu, May 31, 2012 at 12:25:42PM -0700, Joe Perches wrote:
>
>> -Al Viro <viro@ftp.linux.org.uk>
>> -Al Viro <viro@zenIV.linux.org.uk>
>> []
>> +Alexander Viro <viro@ftp.linux.org.uk>
>>
>> I think I've never seen that name before.
>
> *snort*
>
> Same thing, but I prefer to go by the former variant (and I normally
> use zeniv.linux.org.uk for s-o-b, etc.)
I changed your name to the short form in the current version of the
.mailmap file at my Github repository.
Does your comment in parentheses mean that your "ftp.linux.org.uk" and
"www.linux.org.uk" addresses
(c|sh)ould be mapped onto "zeniv.linux.org.uk"?

> The real question is, why bother with all that stuff?  Somebody sees
> slightly inaccurate commit counts (in my case, that would be having
> patches posted from aviro@redhat.com counted separately from those
> posted from zeniv/committed in my trees)?  Who _cares_?
If no-one would care about correct name mappings, why does the
.mailmap file in Git exist at all? Or websites like Linux Kernel Patch
Statistic
<http://www.remword.com/kps_result/>? The latter even states on its
first page: "Request for help: Although I merged some mail addresses
which identify one person, and I also identified some person's
employers, I think there must be some miss."
