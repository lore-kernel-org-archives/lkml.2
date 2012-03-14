Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031043Ab2CNVpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:45:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964781Ab2CNVpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:45:40 -0400
Message-ID: <4F611169.2020205@redhat.com>
Date: Wed, 14 Mar 2012 17:45:13 -0400
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        "\"Eric W. Biederman\" (commit_signer:2/9=22%)" 
	<ebiederm@xmission.com>,
        "Joe Korty (commit_signer:2/9=22%)" <joe.korty@ccur.com>,
        "David Howells (commit_signer:2/9=22%)" <dhowells@redhat.com>
Subject: Re: [resend][PATCH 1/3] mqueue: revert bump up DFLT_*MAX
References: <1323470163-8723-1-git-send-email-kosaki.motohiro@gmail.com> <4EEE3124.7070605@gmail.com> <20111218103836.258eedb8.akpm@linux-foundation.org> <4F610D81.3020300@redhat.com> <20120314143832.286b497e.akpm@linux-foundation.org>
In-Reply-To: <20120314143832.286b497e.akpm@linux-foundation.org>
X-Enigmail-Version: 1.3.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF3A0BD48CDE484153EB41375"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF3A0BD48CDE484153EB41375
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/14/2012 05:38 PM, Andrew Morton wrote:
> On Wed, 14 Mar 2012 17:28:33 -0400
> Doug Ledford <dledford@redhat.com> wrote:
>=20
>> This has obviously fallen through the cracks.
>=20
> It sure has.  Please dig out whatever is the currently favored
> patchset, refresh, retest and resend, with changelogging which fully
> covers the reasoning and decision process?

OK, completely redoing patch set then against current Linus tree.

Motohiro, would you be so kind as to resend my your patches that went on
top of mine and I'll create a complete patch set?

>> so that if there are any apps out there that have been coded to expect=

>> this behavior, then there is a workaround path for them until they get=

>> coded
>=20
> We'll be especially interested in the implications of this part.

Certainly.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enigF3A0BD48CDE484153EB41375
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPYRFpAAoJELgmozMOVy/d8cAQAKW/umN/3ukoqG6pOBATI2Xw
a48WMoATMHiz26uI8F/Ukyb0L40vCmrSPXsr3BUvyPqc3POsZbyeLzEMsMy/QyqL
FvyfOBD+mEVZNcEWDLXin4v3P0YJ1v30qv+Plgh2HIbfxFkEreKq3spr8UH5Y/FH
g9vdqE4eXN5jaePlTC3SeY8co+7VFRj/AOT930XQOtB2qyE+SzfRBWW5VpZG0ofF
Vs3cZX9rH1aGUN3hlyiHZqHm4sQdt/H1DGPwUYEM5PFjQdoQUtssadH8Fp0JwehY
sucpvFpaCdpQAneVTMvNs4L9f1l5yEVWgE3TwptvGIVeEPTH+6JUrLGw+As50J5b
w6MTcnAUWGEzjpzuOK1F+eUAj9SfzejUQv56MtHY3e1YqPGNrt2TpLsW+COBBlhD
Iv/iV8XN/fSI9yrGfdGfM/3nToxfEmNuVWZxASQcgfRGyKa08jFa7Y8iPKJq2eWu
E9LqJLoSLxsz6rL4UlyCg3ssDh0xe9CYKAVj5o1lq4gUcIUTx0naoRBrugJg72JP
VBviDhoxntVfcm8VIjhlh/vaPJDcXtqXpynH4OyJf3JlQ94yPPpqJNk0RamdDb2o
5tCX55NCJwi/vbzsmG57IsK1/Zl7pjI2lNV3WrXUMKG/euCnR8fo4+xO61uP3JZU
TaZ4dd/Elp7wZ7Fs4lxF
=Ju7l
-----END PGP SIGNATURE-----

--------------enigF3A0BD48CDE484153EB41375--
