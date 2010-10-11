Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab0JKBKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 21:10:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57553 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab0JKBKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 21:10:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NLx7+xxlZ5rOg9LtZJa8hj1cf/UVszWtbiWP1t7nsvTqDByIpewQvVrYSbrmY9uDaC
         MPBIHULND3TxbANgsCxdfTJ4QX7Q/zWEWaMWpSRmeWx2OgWpBEJM0kqYrAHEe1wr19PF
         qMBo9/bqqPc3Zp7cMGCsLUWzPHKMMbG536yFk=
Date: Sun, 10 Oct 2010 21:09:56 -0400
From: tmhikaru@gmail.com
To: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later
Message-ID: <20101011010956.GA7334@roll>
References: <20101001035321.GA2360@roll> <20101001094814.GA5029@roll> <20101003030254.GA4901@roll> <1286095268.2144.119.camel@laptop> <20101003121209.586f7b6b@schatten.dmk.lab> <1286107478.2144.177.camel@laptop> <20101003171823.GA19129@roll>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20101003171823.GA19129@roll>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 03, 2010 at 01:18:23PM -0400, tm@ wrote:
> I screwed up and sent this incorrectly to only Peter originally, resent to
> everyone else too.
>=20
> On Sun, Oct 03, 2010 at 02:04:38PM +0200, Peter Zijlstra wrote:
> > On Sun, 2010-10-03 at 12:12 +0200, Florian Mickler wrote:
> > > On Sun, 03 Oct 2010 10:41:08 +0200
> > > Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > > On Sat, 2010-10-02 at 23:02 -0400, tmhikaru@gmail.com wrote:
> > > > >  The load average statistic is indeed broken somehow, and I
> > > > > did bisect it down to where the problem began, however there seems
> > > > >  to be no
> > > > > performance problem related to it I can find.
> > > >
> > > > Chase, anything you can see broken with this stuff?
> > >
> > > Peter, do you think it would be worthwile to test a kernel with the
> > > low load-averages in NOHZ=3Ddisable mode? The bisected commit claims =
to
> > > fix a NOHZ issue with the load average. So if the new figures are the
> > > correct ones, they should be somehow similar to the figures before
> > > with NOHZ? Or am I on the wrong track here?
> >
> > No, that makes sense, but there is of course the distinct possibility
> > that the patch wrecked the !nohz path as well. So ideally you'd have to
> > compare NOHZ=3Dn with this patch reverted and NOHZ=3Dy with this patch =
in
> > place.
> >
>=20
> That'd be easy for me to do if you want. given I use CONFIG_NO_HZ=3Dy
> in my kernel .config, that's tested the 'patch already in place' path rig=
ht?
> I'll try setting up a kernel build with CONFIG_NO_HZ=3Dn if that's what y=
ou
> want me to test. I unfortunately am not entirely sure if that's what I ne=
ed
> to alter though, so please get back to me and let me know so I can test i=
t.
>=20
> Tim McGrath


I haven't heard any feedback from anyone about this since I sent this
message. Is there anything else I can do to help nail this problem, is it
already solved, or ... what? What's going on?

Tim McGrath
--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTLJj5JEncCrqzVruAQLDXAf+K65TOVvV/erPJqfqZLjI5t+XKM/jizFd
ex473WxKbZ0CMXwH55QeZtlnfr02BMazjph08foVnURvmkPtZyWeWgvvBeYasDJc
65qkF7e9j05FXco4Zrj5TJAr4gomejKyoPG2IRidSPehYjpBqweMkINlrQxGMELS
J7m1mimO975asPA+fiWz+QmFUoomMng4XtUzJ8NNb5c/PMNdPCAtfaNWZOIcCZrn
plAvUiIf6vpnO3Jn9oyK8EjzWvLwXwaS1sub1n4xUCoynF8cHh2eaZorwmRWAALD
fYCs8wLpSK8jv8PViqxTobywPU2sMSF6eLdPHh4HPZOBpHg1HU68xA==
=ekkj
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
