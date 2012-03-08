Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab2CHUXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:23:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758638Ab2CHUXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:23:05 -0500
Date: Thu, 8 Mar 2012 14:22:57 -0600
From: Clark Williams <williams@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: John Kacur <jkacur@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        rt-users <linux-rt-users@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH-RT] preempt.h: Fix implicit declaration of
 'preempt_check_resched_rt'
Message-ID: <20120308142257.145e0968@redhat.com>
In-Reply-To: <1331237840.25686.470.camel@gandalf.stny.rr.com>
References: <1331237591-4406-1-git-send-email-jkacur@redhat.com>
	<1331237840.25686.470.camel@gandalf.stny.rr.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LuFE.LJSrYG2aSfCDYHFWHE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/LuFE.LJSrYG2aSfCDYHFWHE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 08 Mar 2012 15:17:20 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2012-03-08 at 21:13 +0100, John Kacur wrote:
> > When building a non-preempt kernel where CONFIG_PREEMPT_COUNT is not
> > defined the following build break occurs.
> >=20
> > /home/jkacur/linux-rt/block/blk-softirq.c: In function =E2=80=98trigger=
_softirq=E2=80=99:
> > /home/jkacur/linux-rt/block/blk-softirq.c:54: error: implicit declarati=
on of function =E2=80=98preempt_check_resched_rt=E2=80=99
> > make[2]: *** [block/blk-softirq.o] Error 1
> > make[1]: *** [block/blk-softirq.o] Error 2
> > make: *** [sub-make] Error 2
> >=20
> > This patch fixes the build error by adding a define to the
> > !CONFIG_PREEMPT_COUNT section.
> >=20
> > Signed-off-by: Clark Williams <williams@redhat.com>
>=20
> Why Clark's SOB? Did he write it and send it to you?

I suppose to be technically correct it should have been a Tested-by:

John found it while I was working on it and I tested it for him.

Clark

--Sig_/LuFE.LJSrYG2aSfCDYHFWHE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk9ZFSEACgkQHyuj/+TTEp3kIACguH7BwiC80rl9qQadE+vH802s
gOQAnje4VOoe66LvE/Pyh77qa8CbU4Ys
=+k8L
-----END PGP SIGNATURE-----

--Sig_/LuFE.LJSrYG2aSfCDYHFWHE--
