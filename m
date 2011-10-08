Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab1JHOh4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 10:37:56 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:50386 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1JHOhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 10:37:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Jon Masters <jonathan@jonmasters.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Adrian Bunk <bunk@stusta.de>,
        "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
In-Reply-To: Your message of "Sat, 08 Oct 2011 01:02:13 EDT."
             <1318050133.19519.184.camel@constitution.bos.jonmasters.org>
From: Valdis.Kletnieks@vt.edu
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl> <4E87B885.50005@zytor.com> <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com> <20111003093239.GB25136@localhost.pp.htv.fi> <y0mobxyjazi.fsf@fche.csb> <20111003180441.GD3072@localhost.pp.htv.fi> <34045.1317760188@turing-police.cc.vt.edu> <1317916702.19519.1.camel@constitution.bos.jonmasters.org> <14191.1317930659@turing-police.cc.vt.edu> <m34nzlbwbi.fsf@intrepid.localdomain> <15324.1318004954@turing-police.cc.vt.edu>
            <1318050133.19519.184.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318084612_9306P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 08 Oct 2011 10:36:52 -0400
Message-ID: <58779.1318084612@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4E90600B.0090,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318084612_9306P
Content-Type: text/plain; charset=us-ascii

On Sat, 08 Oct 2011 01:02:13 EDT, Jon Masters said:

> What I'm saying is that unless you sign something (random text, my
> actual key(s)) in my presence, I can't actually know it was you I was
> dealing with or someone else claiming to be you (or your identity).

Now see, this is *exacltly* why security people have to be pedantic about
stuff.  What you originally asked for was "sign random data to demonstrate
control of the key", and I pointed out that being able to sign a key was as
good as being able to sign random data to prove control of the key.

However, it now turns out that your *actual* worry is "binding the person
who controls the key with the person who controls the e-mail", which is
in fact a valid concern for some situations, and as pointed out, requires
a bit more effort to establish.

However, you have to remember that *all* real-life identity proofs are to
some degree probabalistic.  How do you know your lawyer is a *real* lawyer
and not somebody with a fake degree?  Mostly because the other lawers
in town and the judges are convinced he's a lawyer too.  Same goes for
your doctor - how do you know he *really* went to med school?  Even calling
the med school and verifying only proves that somebody with that name went
there that year.  And yes, every year we hear about a few fake lawyers and
doctors on the news.  But society seems to muddle along just fine anyhow.

(Incidentally, something most people don't realize is that the entire debit/credit
card industry is *designed* with the assumption that between 2 and 4
percent of all transactions will turn out to be fraudulent in some way.  So
everybody keeps a small buffer for chargebacks and life goes on).

Similarly for PGP -  it's not *that* hard to create a totally new e-mail
account, a new name, get a fake ID, go to a few key signings, and have a nice
validated bogus PGP ID.  However, do we really *care* in that case?  Probably
not.  What we *care* more about is somebody creating a fake ID in somebody
else's name.  And that turns out to be rather self-limiting - all it takes is
*one* person to send the real person an e-mail that says "Glad to meet you at
the keysigining last week", and the ruse is revealed when the real person
realizes he wasn't *at* the keysigning.

And even if the identities *are* perfectly confirmed, that doesn't remove all
the risk.  You can have somebody you've known for years, do background checks,
and be 100% convinced he's the real person.  But if you then use PGP to encrypt
the secret plans for the revolution and e-mail it to him, PGP says nothing at
all about whether he's in reality a government mole who's infiltrated your
orgainization...

That's why nobody worries too much about the "is it really him?" side - the
world is full enough of properly identified but duplicious people to worry
about the few who have fake identities and are duplicious. ;)


--==_Exmh_1318084612_9306P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOkGAEcC3lWbTT17ARAsd1AKDcWJRof6kVICI0FDtDMwFozvvDUACg5NaK
TgCUkK8DTquzg8iQAdQ9Pis=
=dfth
-----END PGP SIGNATURE-----

--==_Exmh_1318084612_9306P--

