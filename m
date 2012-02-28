Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966151Ab2B1XI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 18:08:57 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34297 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965655Ab2B1XI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 18:08:56 -0500
X-Sasl-enc: 2AlQdXekEv3kkt7smY2vAPkTmeDlWVH3Tz5+WD5yTo+0 1330470534
Message-ID: <4F4D5E84.8090404@imap.cc>
Date: Wed, 29 Feb 2012 00:08:52 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.27) Gecko/20120215 SUSE/3.1.19 Thunderbird/3.1.19
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Karsten Keil <isdn@linux-pingi.de>, Jiri Slaby <jslaby@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, Hansjoerg Lipp <hjlipp@web.de>,
        gigaset307x-common@lists.sourceforge.net,
        Jiri Slaby <jirislaby@gmail.com>, David Miller <davem@davemloft.net>
Subject: Re: "whitespace coding style cleanup" broke coding style
References: <4F4B45F6.4090706@suse.cz> <1330361549.9942.7.camel@joe2Laptop>	 <4F4D15E1.3090306@imap.cc> <1330466751.21481.18.camel@joe2Laptop>
In-Reply-To: <1330466751.21481.18.camel@joe2Laptop>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 28.02.2012 23:05, schrieb Joe Perches:
> On Tue, 2012-02-28 at 18:58 +0100, Tilman Schmidt wrote:
>> Please remember to CC the maintainers of the affected code this time.
> 
> Karsten Keil is the nominal maintainer for
> all of drivers/isdn.

Look again.

> ISDN SUBSYSTEM
> M:	Karsten Keil <isdn@linux-pingi.de>
> L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
> L:	netdev@vger.kernel.org
> W:	http://www.isdn4linux.de
> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/isdn-2.6.git
> S:	Maintained
> F:	Documentation/isdn/
> F:	drivers/isdn/

GIGASET ISDN DRIVERS
M:	Hansjoerg Lipp <hjlipp@web.de>
M:	Tilman Schmidt <tilman@imap.cc>
L:	gigaset307x-common@lists.sourceforge.net
W:	http://gigaset307x.sourceforge.net/
S:	Maintained
F:	Documentation/isdn/README.gigaset
F:	drivers/isdn/gigaset/
F:	include/linux/gigaset_dev.h

HTH
T.

- -- 
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk9NXoQACgkQQ3+did9BuFv95QCfd/TznBrdI/a6TsE+ch3bH0cO
sJ0An2VcWci5lpra41JveYP8JdZnPA5s
=o+jZ
-----END PGP SIGNATURE-----
