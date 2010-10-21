Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab0JUUaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 16:30:04 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48704 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513Ab0JUUaB (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 16:30:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        clemens@ladisch.de, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org
Subject: Re: HDA: no sound [was: mmotm 2010-10-20-15-01 uploaded]
In-Reply-To: Your message of "Thu, 21 Oct 2010 21:40:08 +0200."
             <s5h8w1rxrl3.wl%tiwai@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org> <4CBFEE94.7020103@gmail.com> <s5hlj5sc7do.wl%tiwai@suse.de> <4CBFF25C.2080908@gmail.com> <s5hfww0c6oj.wl%tiwai@suse.de> <4CC085F5.9070905@gmail.com> <s5heibjxsi4.wl%tiwai@suse.de> <4CC092BC.9060504@gmail.com>
            <s5h8w1rxrl3.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1287692957_4908P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 21 Oct 2010 16:29:17 -0400
Message-ID: <5220.1287692957@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1287692957_4908P
Content-Type: text/plain; charset=us-ascii

On Thu, 21 Oct 2010 21:40:08 +0200, Takashi Iwai said:
> > >>>   commit de8c85f7840e5e29629de95f5af24297fb325e0b
> > >>>     ALSA: HDA: Sigmatel: work around incorrect master muting
> > >>
> > >> Reverting this one helps.
> > > 
> > > The latter one?
> > 
> > Yeah. Otherwise I would write it to the former :).

Confirming - reverting that one commit fixes sound on my Dell laptop as
well.

> This might be a user-space issue, then.

That would be icky, if we have to lockstep a 2.6.37 kernel upgrade to
an alsa-lib upgrade.  Stuff like udev and perf having to lockstep is
bad enough...

> Could you try once the latest alsa-lib?  If you are using SUSE packages,
> the snapshot rpms are available on OBS multimedia:audio:snapshot/alsa
> repo.  (The version number of the package is still 1.0.22, but don't
> care; I just forgot to change the spec file.

Hmm... on my laptop, Fedora Rawhide is showing:

% rpm -qi alsa-lib
Name        : alsa-lib                     Relocations: (not relocatable)
Version     : 1.0.23                            Vendor: Fedora Project
Release     : 1.fc14                        Build Date: Fri 16 Apr 2010 07:48:17 AM EDT
Install Date: Sun 18 Apr 2010 03:22:04 PM EDT      Build Host: x86-02.phx2.fedoraproject.org
Group       : System Environment/Libraries   Source RPM: alsa-lib-1.0.23-1.fc14.src.rpm
Size        : 1188301                          License: LGPLv2+
Signature   : (none)
Packager    : Fedora Project
URL         : http://www.alsa-project.org/
Summary     : The Advanced Linux Sound Architecture (ALSA) library
Description :
The Advanced Linux Sound Architecture (ALSA) provides audio and MIDI
functionality to the Linux operating system.

Is that "recent enough", or do I need to find something newer?



--==_Exmh_1287692957_4908P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMwKKdcC3lWbTT17ARAlF/AJ9Ds/YZVkn1C4CvRynOwoA24UyBNQCgsWhp
aEj2r+EBbW6pVz7K4Bzi7xo=
=X41X
-----END PGP SIGNATURE-----

--==_Exmh_1287692957_4908P--
