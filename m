Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2GUXVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 19:21:16 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49094 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab2GUXVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 19:21:14 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: 0xB16B00B5? Really? (was Re: Move hyperv out of the drivers/staging/ directory)
In-Reply-To: Your message of "Fri, 20 Jul 2012 17:03:59 +0200."
             <CAFLxGvwqKLhPWNfUJYm1KDXWEX1DNhPBGGApYFqMM0BsB87iig@mail.gmail.com>
From: valdis.kletnieks@vt.edu
References: <6E21E5352C11B742B20C142EB499E048081EB789@TK5EX14MBXC124.redmond.corp.microsoft.com> <20111004170415.GA1320@suse.de> <6E21E5352C11B742B20C142EB499E048081EB86F@TK5EX14MBXC124.redmond.corp.microsoft.com> <20111004193414.GA15672@suse.de> <4FFFF711.8040003@redhat.com> <426367E2313C2449837CD2DE46E7EAF923547292@SN2PRD0310MB382.namprd03.prod.outlook.com> <20120719210709.GA32031@kroah.com> <426367E2313C2449837CD2DE46E7EAF9235475EE@SN2PRD0310MB382.namprd03.prod.outlook.com> <20120719220142.GA1513@kroah.com> <426367E2313C2449837CD2DE46E7EAF923547620@SN2PRD0310MB382.namprd03.prod.outlook.com> <20120719232832.GA6317@kroah.com> <426367E2313C2449837CD2DE46E7EAF9235476BC@SN2PRD0310MB382.namprd03.prod.outlook.com> <87fw8mlv7e.fsf@nemi.mork.no> <426367E2313C2449837CD2DE46E7EAF923547782@SN2PRD0310MB382.namprd03.prod.outlook.com>
            <CAFLxGvwqKLhPWNfUJYm1KDXWEX1DNhPBGGApYFqMM0BsB87iig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1342912870_3823P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 21 Jul 2012 19:21:10 -0400
Message-ID: <60467.1342912870@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.216.180 mail-qc0-f180.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.500B3969.004F,ss=1,re=0.000,fgs=0,
	ip=71.62.120.57,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1342912870_3823P
Content-Type: text/plain; charset=us-ascii

On Fri, 20 Jul 2012 17:03:59 +0200, richard -rw- weinberger said:
> On Fri, Jul 20, 2012 at 4:00 PM, KY Srinivasan <kys@microsoft.com> wrote:
> > Thank you for your interest in fixing this problem. When we decide to change this
> > ID, we will conform to the MSFT guidelines on constructing this guest ID.
> >
>
> I'm wondering why it hasn't been conform to the MSFT guidelines from
> the very beginning on?

It's a lot easier to sneak something cute into code when it isn't maintained in
git repositories and mailing lists readable by everybody and their pet llama.

I'll admit to not doing a *lot* of extensive review, but I try to at least read
Kconfig patches (mostly out of self-defense so when I do a 'make oldconfig' I
get presented with something useful ;)  - and it's amazing how often I spot
issues in stuff that's presumably already had several pair of eyeballs look at
it already.

Probably what happened - some programmer had a 60 hour week, wrote the code on
a Friday and had a sudden attack of the sillies, and it went through a code
review meeting, but they had to cover 800 lines of code in a one-hour meeting
so nobody looked *too* close...


--==_Exmh_1342912870_3823P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUAs5ZgdmEQWDXROgAQJL6w/5Ada8xxcbAa6Tb9mS79W5p4oz8Pma8O8L
B2hEMuBVhRci3DoxKYUel/g52ZbsNYcKI4dSV3u0O2XjJi7/ZxuGIDtX2zh18x1u
OVr/A92jwI9ZtIhPe9+hrZaMhPLe29/4lHP7aFV3WDl6hus0ZuL57KaYU9+P7vSk
Bqxk+8ZF1WclGn/t/rMmL6VIPzeFRmZTtQl4wUWuP9v343mJtDj5yYIOr9M2h3+z
pLDodg8gCx8+FiRjowmImDlB40+708cRbfcI4NSvUNo6sN4s/4Bg0+y2Tby1QqJU
FcSVIEcQ90j888IHyN/Wcx4AnhtTkH4WtpKPA5zaRsuJmdXspoowy+zDiwZe0BOc
lm+ylYgY/srZ8lT4DE+zv6+zoZf+9mxJVQv1mfEo1UmQOcn9TNfgpspJkkFi3oum
58bY9TQbiZDNHtMUjiiqIws2mh48ZWZZ9Uih/Z27rCntrDD1sL/oj2dMKls1nxtZ
UxRbDSIc0xrwzvF4usvrgu9w4FIwbfR+S5ytrETBFvAlX/xukNOJ+/H6ogJ+2P8b
K1yaSAyVxNA7kwY48r8QNDlyBw426SSmiRSmtAyU3CIfgUXqO1LAPNlr2LrijGNz
2fDV5BB/n3Ld7dvBkBGflo+CyawT1JRoVXmgBpsCHUAhlI5+YSlZ3dqPVT1zc6D4
Mhe9fV66G0Y=
=5eQL
-----END PGP SIGNATURE-----

--==_Exmh_1342912870_3823P--

