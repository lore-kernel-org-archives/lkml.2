Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144Ab1FXAAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 20:00:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58728 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759805Ab1FXAAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 20:00:13 -0400
Date: Fri, 24 Jun 2011 10:00:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: brudley@broadcom.com, henryp@broadcom.com, rvossen@broadcom.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (staging related)
Message-Id: <20110624100005.f9f59ddf.sfr@canb.auug.org.au>
In-Reply-To: <20110623215115.GB10969@kroah.com>
References: <20110609172745.dfd3a298.sfr@canb.auug.org.au>
	<20110609184127.GA2760@kroah.com>
	<20110609192243.GA3980@kroah.com>
	<20110610160548.529797c7.sfr@canb.auug.org.au>
	<20110610160938.cd01c408.sfr@canb.auug.org.au>
	<20110610223423.GB15868@kroah.com>
	<20110615142155.bd538b73.sfr@canb.auug.org.au>
	<20110616191448.GA10255@kroah.com>
	<20110623103503.cd9e7e70.sfr@canb.auug.org.au>
	<20110623215115.GB10969@kroah.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Jun_2011_10_00_05_+1000_QqSli_p7ukvpyCel"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Jun_2011_10_00_05_+1000_QqSli_p7ukvpyCel
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 23 Jun 2011 14:51:15 -0700 Greg KH <greg@kroah.com> wrote:
>
> Sorry, I'm away from home, with a very spotty internet connection, on
> vacation, so it's hard to get this done at the moment.  I'll get to it
> on the 27th when I return.

I can understand vacation as well :-)

Thanks.  I will use Ralf's (arch restricting) patch until you come up
with something better.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Jun_2011_10_00_05_+1000_QqSli_p7ukvpyCel
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOA9OFAAoJEDMEi1NhKgbsknkH/0gSZt7xZPUaIRXYO32rencT
qkGguDIVhlKLGQEN3ahFN0kr3N/ZPi5OmuGhmg2ExtnlDU2sV1x+/VVE9v6fZsrj
0qTMDYCE+B9CxZw6fgWcNKJu8noDK6LEQ3Txlo/sbjWaxRhYqEyxmrJmTvkCEpDS
mR3/9UbaDLpVSnKPzRUHqrzJdwjT2H5I/Oo49N2oQLqG4IPB7D8DxPzscCQfIOYY
EHWb7wGPN/jyETR6EEtWo/HrFBZRzuo6tqNr22XSR3ryq6E2jEtAurnh4GteSWQI
kuqR2WiQTDGufEfg4gjz7SmsadzWhhdEefomt1AqNVEA1iLWm5b35rFx6inXSc8=
=MarY
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Jun_2011_10_00_05_+1000_QqSli_p7ukvpyCel--
