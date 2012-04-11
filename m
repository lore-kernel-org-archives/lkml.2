Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab2DKAEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 20:04:05 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:48014 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759834Ab2DKAED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 20:04:03 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.4-dev
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
In-Reply-To: Your message of "Mon, 09 Apr 2012 16:22:38 -0700."
             <4F836F3E.9090207@zytor.com>
From: Valdis.Kletnieks@vt.edu
References: <20120215143606.GA14037@redhat.com> <20120215160652.GA17680@redhat.com> <20120215162752.GF4533@moon> <20120409151027.7f3e0fa5.akpm@linux-foundation.org> <20120409222443.GW1625@moon>
            <4F836F3E.9090207@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1334102540_1904P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Apr 2012 20:02:21 -0400
Message-ID: <8169.1334102541@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4F84CA0E.001D,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1334102540_1904P
Content-Type: text/plain; charset=us-ascii

On Mon, 09 Apr 2012 16:22:38 -0700, "H. Peter Anvin" said:
> On 04/09/2012 03:24 PM, Cyrill Gorcunov wrote:
> >>
> >> Having re-read most of the (enormous) email discussion on the kcmp()
> >> syscall patch, I'm thinking:
> >>
> >> - Nobody seems to understand the obfuscation logic.  Jon sounded
> >>   confused, Oleg sounds confused and it's rather unclear what it does,
> >>   how it does it and why it does it.
> >
> > The obfuscation logic was done with great help from hpa@. And the main
> > idea was to have ordered results after obfuscation. Per-type noise increase
> > randomization of results. So Andrew, I actually dont know what to add
> > here. We don't want to provide kernel order back to user-space in
> > naked manner.
> >
>
> The obfuscation logic is to provide a 1:1 mapping but which doesn't
> preserve ordering, thereby avoid leaking information of kernel pointers
> to user space.

Oh, OK... Ignore my previous note then.  But we should lose the comment
that implies we have an ordering?

--==_Exmh_1334102540_1904P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT4TKDAdmEQWDXROgAQLrZw//ekaoXqNZljXABAr8WtgWdZzz8HVQWjKP
q1Sy+Bc18DNWORLCGjM/a0+VuGEpaG8nMN4ecOEvIlVOjFEnaubNKaBYCEUL1xth
6KqEpcurzWyVnPNUxGqRajIS5XYfflr+b8D0S/WxQhIgjUQTo33UXHUsfV45xp40
AOuDLz/QA0cbEhLM498p2Gmxx08/EubqZlnefRBiGuJghojnS/1tFtgpjtzAsubY
RR3eVMzpwoeDsXQi9FJD9VpWrI75hwq+jCES2SiQCIJPWc1aW3dYHZ3g4NU/A2Ma
mI/c5ogLmmElZJNRlnY/ARLnx6/3ArGn5IjPXdwczDI8C2KaGlHK/Av9BKbNliIX
1IcCtkLj6AK3jooV1v6MfHonvaW/VFvlHAhKiZWvHsQgwbu4jcg6uhhckBOGy2tp
n6E8H9aAhdOrXUPQZwfN6Ug8ZCJEwsUZ17CApvSrrECWfsVYaslUxCmRPEjdhBPE
wZ4cWHKsxnFSeXOYry8hucjZz1Agf23uxQg3/z5Aoh4vd7p665f2OftPxF5P8pvH
5ry7P9dGNCe+wE4CnrcrY61bL/mCFnuZE/SiazjuhdvCV2oD+bD+fQCc60cTjuwq
iwzn0u2PJJ/n2SlWQzhUZ7Nfi94BPlNVJEY1+3Jl5XULxj1ZawwPt4yTcjk57bgy
qqcPneg49WA=
=/4d3
-----END PGP SIGNATURE-----

--==_Exmh_1334102540_1904P--

