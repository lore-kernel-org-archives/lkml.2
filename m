Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1DISm5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 14:42:57 -0400
Received: from wnohang.net ([178.79.154.173]:47598 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab1DISm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 14:42:56 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 60BEF2400A
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net D0AE32400A
Date: Sun, 10 Apr 2011 00:12:45 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Michael Witten <mfwitten@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use the environment variable PYTHON if defined
Message-ID: <20110409184245.GA5115@Xye>
References: <20110326224408.GA1336@Xye>
 <20110328144721.GB17872@ghostprotocols.net>
 <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
 <20110329181524.GA5140@Xye>
 <AANLkTi=3Wq3Xt-QFR-FLRQ1kBjpWjaBZNFpOiE_T15WH@mail.gmail.com>
 <20110329204024.GA20824@ghostprotocols.net>
 <3a97df19-e376-412a-95be-37ffde765cc3-mfwitten@gmail.com>
 <20110408211709.GA5155@Xye>
 <5f5948dd-2c38-4ed3-8544-99c137204d07-mfwitten@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <5f5948dd-2c38-4ed3-8544-99c137204d07-mfwitten@gmail.com>
X-Operating-System: Arch linux x86_64 2.6.38.2-bldit-db-FAE
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

* On Sat, Apr 09, 2011 at 01:24:57AM +0000, Michael Witten <mfwitten@gmail.com> wrote:
>On Sat, 9 Apr 2011 02:47:09 +0530, Raghavendra D Prabhu wrote:
>
>> Apologies for the delay. I am getting a merge conflict
>> with master now, it may need to be rebased after the
>> 1b7155f7de119870f0d3fad89f125de2ff6c16be commit.
>
>Erg... `git am' isn't really any help there, as it doesn't
>leave information in the files about where there are conflicts;
>I had to resort to running `git merge' by hand.
>
>Anyway, I've sent along (as replies to this email) *2* patches;
>the first one:
>
>  perf tools: Makefile: Clean up `python/perf.so' rule
>
>is just a minor tweak of the offending conflict, and the second
>one is the updated patch proper:
>
>  perf tools: Makefile: PYTHON{,_CONFIG} to bandage Python 3 incompatibility
>
>They should apply cleanly on Arnaldo's `perf/urgent' branch from
>his repository here:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6.git
>
>the tip of which contains the commit you mentioned:
>
>  1b7155f7de119870f0d3fad89f125de2ff6c16be
>
>Arnaldo, is it generally a good idea to branch from `perf/urgent'
>in order to keep things up to date?
>
>Sincerely,
>Michael Witten
Tested it on the perf/urgent branch. Works great. I have a question
regarding the message that is displayed. It says "No Python.h found"
when variable PYTHON is not set correctly, it would be better if it said
"No Python.h for Python 2.x found" since the header file supplied by
Py3k is also Python.h and in the rare case of only Py3k installed on the
box, it may be confusing.

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNoKilAAoJEKYW3KHXK+l3DaYH+gNVKJxEJjoCepPu45GgUVUb
KDvMAHRSbFEIkIdtLEgIC9ye+CSYIzzqOKLH0uQFkkhK/oqdGJ94LHRpCrII3BPa
wmmPyLJ/VJQBl7e+vgdFOztNXxQlWVRdLlNqyZJW8XFW60LBnHs/f9qo3UuCcyr4
JuYPMNj5h8Rtq1FMls3LG9Fp5kw5s/gUH/4tLynzsyE6qV9Sz5TaLwUrk99h4tzN
JMkYuuN+gmyLYypjzS299oHpOL38WSl/bxTnpAoYbWn/0l7DwMS8b23i147cnBdt
2h9sMQsSNPoN0KLqDkPsz7qhbIBJytW7yZyEHKKA1BaGYeZAiSir+e3ViMXoBss=
=+Gxo
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
