Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab2ENQki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:40:38 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40933 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2ENQkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:40:36 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Mark Lord <kernel@teksavvy.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Joe Perches <joe@perches.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length record buffer
In-Reply-To: Your message of "Sun, 13 May 2012 09:22:04 -0400."
             <4FAFB57C.40906@teksavvy.com>
From: valdis.kletnieks@vt.edu
References: <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com> <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com> <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com> <1336571457.30189.29.camel@joe2Laptop> <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com> <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com> <20120509230649.GA10695@kroah.com> <1336617045.25027.2.camel@mop> <CA+1xoqft4aM_qedn+TDx0z8creS_4mFf3S+4SUNjz0pe+=YHAg@mail.gmail.com> <20120511151944.GA6990@kroah.com> <CA+55aFz8-96rHLfqRrRSgFAzOFmyDaDKSB15WKkCoUssHq8R-A@mail.gmail.com> <CAPXgP11teuiH0cPRrhWdvKCW1jtq4_6wkH21wgRT6UpDF0G1gQ@mail.gmail.com> <CA+55aFyG2jQFURwWebMWw7bAt3=zbXRsHSOtZVYBw-frUXqiRg@mail.gmail.com> <CA+1xoqf5YbkOJgQJWOgck0NpqGzGtxtHHJASZKHvwVuBzkKK6A@mail.gmail.com> <CA+55aFyeXdUyj_OzccctFSj1f4su1G8DyxiQwD4W5sV9Dh0Zpg@mail.gmail.com>
            <4FAFB57C.40906@teksavvy.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1337013632_2289P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 14 May 2012 12:40:32 -0400
Message-ID: <16580.1337013632@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.213.52 mail-yw0-f52.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4FB13584.0012,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1337013632_2289P
Content-Type: text/plain; charset=us-ascii

On Sun, 13 May 2012 09:22:04 -0400, Mark Lord said:
> On 12-05-12 02:35 PM, Linus Torvalds wrote:
> > I dunno. The above is what I would have liked to see quite often. I
> > look at dmesg, and notice that I had an WARN_ON_ONCE in it, and I have
> > no idea when it happened, because the "seconds since boot" is totally
> > useless information for me, as I'm too lazy to try to use /proc/uptime
> > to calculate what it is.

> Look in syslog ?

Oddly enough, just yesterday I was looking in dmesg on one of my servers, trying to
find a hint of why syslog and a number of other things had failed to start at boot...



--==_Exmh_1337013632_2289P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT7E1fwdmEQWDXROgAQLB/BAAnojwu1Cw4/3lqKxJ5ng9mxVbeVwTFKcl
ZW6wig0cX6QmmMdQquH9YJ6kYFV0Pv/MOOthf2rW76kFjdj4IoMWfuudjVeNc+5I
tCyDY9bcG3UbKaI6215zFVsbe+0jIpurauDD8CMKnaVC+Z6G2wxZP2Fk3d0EhQ+U
ae5+J/uLoFd8xq/eJW8Z9deRWqBDYo3BOlBb4ZHBvdGYA2zmqsnItHeznRwBCbez
xzMeHX31vC82ahtM177OWQA7Nc5YDW7FfGk4OGDyuTZFuqtqkMkxYMCw06cMJbq+
a6vunkV7zoX2dxangncXgVyyelBt9DRcPyKeWJzHcFczaohYnxQXdHxPnRPBqmDa
mV//eZTFw8zqYPvsOE0/TcZ37Z5Wg7GgZK9WaILV9HTsYcdCm7Xn7DrOk3J3r97t
LMRUjiFDI39Rb7CyrNay+RSyHNelxF5TKDkMtwxDm0465U2mo12hULO9tndokpQ1
pl1X5L4NAeiEfx8e6zhJ20F+CFfuQvA3L5hhlFGg+ygoQtPvyPRiEumclC2ERceq
sYqK3NtDQa61ThDL4yGXU3Bt5ETdwb+QQFflcFu7X4Cwn2TGDqmUTB3tuVnFOm2d
hOjxxsutDDF95noMCJ21XyT0cXARUTyb4rHCeQrJ8ipiXKUpCxMgf/VmP6ykEPuL
ulrFv8a1uTk=
=KPqK
-----END PGP SIGNATURE-----

--==_Exmh_1337013632_2289P--

