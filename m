Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965916Ab2B1R7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:59:03 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41584 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965746Ab2B1R7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:59:00 -0500
X-Sasl-enc: gegAUcw9csM1G/j44h4aPmoYnQK/9+hkNurHCCHQNePK 1330451940
Message-ID: <4F4D15E1.3090306@imap.cc>
Date: Tue, 28 Feb 2012 18:58:57 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.27) Gecko/20120215 SUSE/3.1.19 Thunderbird/3.1.19
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Hansjoerg Lipp <hjlipp@web.de>,
        gigaset307x-common@lists.sourceforge.net,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: "whitespace coding style cleanup" broke coding style
References: <4F4B45F6.4090706@suse.cz> <1330361549.9942.7.camel@joe2Laptop>
In-Reply-To: <1330361549.9942.7.camel@joe2Laptop>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 27.02.2012 17:52, Joe Perches wrote:
> On Mon, 2012-02-27 at 09:59 +0100, Jiri Slaby wrote:
>> commit 475be4d85a274d0961593db41cf85689db1d583c
>> Author: Joe Perches <joe@perches.com>
>> Date:   Sun Feb 19 19:52:38 2012 -0800
>>
>>      isdn: whitespace coding style cleanup
>>
>>      isdn source code uses a not-current coding style.
[...]
> It was a first pass and an overall improvement.

I'm not so sure about that, but I'm probably biased.

What grieves me more is how that patch was sneaked in without any
notification to the maintainers of the code in question. With the
customary CC, we could have caught the problems before they reached
- -next.

> I'm working on improving the logging style
> in isdn and will submit more patches soonish.

Please remember to CC the maintainers of the affected code this time.

Thanks,
Tilman

- -- 
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk9NFeEACgkQQ3+did9BuFvG2ACdGL+9IMooAmMAlJwON2kHU+f8
2V4AnjjdZDNwaNGQuLVRKS100TfG6i+e
=FKIs
-----END PGP SIGNATURE-----
