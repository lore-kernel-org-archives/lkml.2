Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab2GUUrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 16:47:53 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41162 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab2GUUrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 16:47:15 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Josh Boyer <jwboyer@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
In-Reply-To: Your message of "Thu, 19 Jul 2012 13:56:50 -0400."
             <20120719175649.GF8469@zod.bos.redhat.com>
From: valdis.kletnieks@vt.edu
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com> <20120713210240.GG1707@redhat.com> <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com> <20120719152618.GD16873@home.goodmis.org> <20120719154521.GC8469@zod.bos.redhat.com> <1342714088.12353.33.camel@gandalf.stny.rr.com> <20120719171918.GD8469@zod.bos.redhat.com> <1342719222.12353.58.camel@gandalf.stny.rr.com>
            <20120719175649.GF8469@zod.bos.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1342903631_3823P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 21 Jul 2012 16:47:11 -0400
Message-ID: <54330.1342903631@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.216.180 mail-qc0-f180.google.com valdis@vt.edu 4 softfail
X-Junkmail: UCE(51)
X-Junkmail-Status: score=51/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=bulk(1),
	refid=str=0001.0A020202.500B1552.0067,ss=3,sh,re=0.000,fgs=0,
	ip=71.62.120.57,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1342903631_3823P
Content-Type: text/plain; charset=us-ascii

On Thu, 19 Jul 2012 13:56:50 -0400, Josh Boyer said:
> On Thu, Jul 19, 2012 at 01:33:42PM -0400, Steven Rostedt wrote:
> > What happens if someone does a yum update, and the kernel requirement
> > changes slightly. The yum update should update
> > this /usr/share/Linux/Kconfig. But it's still set at Fedora X. The
> > kernel can not be updated for these slight changes.
>
> I'm not quite following what you mean in the yum update case, sorry.

I do a 'yum update', and my system won't boot, and the first thing I think of
is "What the fsck did Lennart add as a systemd requirement *this* time?"

:)


--==_Exmh_1342903631_3823P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUAsVTwdmEQWDXROgAQI/vg/+Mwl/UFtBgehl95C0zGz6eyydhDVMPgDa
D18MmzzOmaV9irS7d+rMqaoGFY1f8FOls9D/i+oQLUlfjHPgikWfdfiufWJ62727
L/ftqUqxREAX1QXCBPlEr+nDHKhV/XQR50A3+prh3nkr5HH41uhTMS5BOl5tCx9c
+sAXkVzaE3uFphfP7CIoiKYIYuAToddfnaYI1+hP3fMgXu5s0BL+I8ormQLivV44
gOoMQDsclUtQxJ3tqx648abVD1XIs9xYqjidGZEh90NafmB1/m7dIKYFvDDlKiJu
0e7dLDwIqTlfshI2+6DPncRewxs2Vzh/jMqhYn6qURYfHfO+BssteZJmdHgg5pgm
T9iSgMZHiSGhanPFO7s81zopdTKfzSAdFTTMZfDraaDfiUeRtbAOW/Vev+2CGSlO
x82LheClwnDxdBi/GatUby/+SUn5DPCkzUxqzo82QA9n7K21GYjVGLeK1nf2rD9n
REzlhjTGA4r4XsyDXhtZD51oBMmcZUH+T+MU/4BPGpYXk1idyoxTzKXiUeD/ykZA
kMlRrGOODaD5PDZbsnHVr9otNEJTxpZX6+0FR2NePnIYruQ/mivfKUmZKXSARJ8J
J0QCjXZBFTGxaFBFRwajUK2AwsVAowT4RhwyH5QZ05My0AVQ3sUKvkUWISbKWJx0
IIftofjso3w=
=+3qt
-----END PGP SIGNATURE-----

--==_Exmh_1342903631_3823P--

