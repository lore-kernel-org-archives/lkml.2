Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab1EFLr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 07:47:27 -0400
Received: from csamuel.org ([74.50.50.137]:38164 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab1EFLr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 07:47:26 -0400
From: Chris Samuel <chris@csamuel.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip:x86/urgent] x86, setup: When probing memory with e801, use ax/bx as a pair
Date: Fri, 6 May 2011 21:47:03 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: mingo@redhat.com, hpa@zytor.com, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
References: <1303566747.12067.10.camel@localhost.localdomain> <201105052157.06317.chris@csamuel.org> <20110505121059.GA31473@elte.hu>
In-Reply-To: <20110505121059.GA31473@elte.hu>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@
 =?iso-8859-1?q?=5ESdaXtmdYGRq=0A=09=5B?=>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<
 =?iso-8859-1?q?=7Bn8m=3BX=5F=0A=09g=5CY9LQ=3Dv/b5=60?=)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)
 =?iso-8859-1?q?F!1M3=3Dw=3Ai9MsWp=26v=3B=25usOXL=3Bw=0A=096kF=3FwAZjss=2E?=
 =?iso-8859-1?q?+y?=(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3350936.vY14niAmun";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201105062147.09398.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3350936.vY14niAmun
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, 5 May 2011 10:10:59 PM Ingo Molnar wrote:

> Thanks for the update!

My pleasure.

> Note that the noapic and the scsi-sync-scan boot parameter suggests
> that  there's two regressions remaining.

Understood, I would guess that the SCSI one would map to the
introduction of the async scsi scanning patch in 2.6.19-rc2
and its enablement in later Ubuntu kernels.

No idea on the APIC one but I'm happy to try and bisect both
cases if you'd like me to try ?

> The stock kernel wont boot - you can work it around via boot
> options but most  users wont be able to do that.

Indeed - though at the moment you can't even install a current
Debian release as the boot loader on the install CD locks the
box up. :-(

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart3350936.vY14niAmun
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATcPfuI1yjaOTJg85AQLb8wgAm0WLUL365Qkhw0bkpOb6qVFbADRdz2iJ
YxZtpxM/VKC9IBi4k/JAWDDcmUwhlkFHizdCwRPJfbgdd9hZuGA4NJ8z2Efc/HKP
jQeleimN9qdb8p8eh1lH4LPObIOFVrW4V9OyDLTMFsn4g9eh4Np9+V3lXM9G8Q30
eqPzoXJSt/s6thbkhtVIWuRuB10tfRcQwulOl2KvYiuKOehN9mnPW8sQopuQLnq4
TbTcyb8S5miANwCD9BjSMGjPd+9AYLJZiPzGGGhWP4D7wEQKH90bCfjY3DcFqSL4
NSBhKg8SXlQCkIq/LWpndDuM6AP/JwbKKPhPpx3FSx2JQQpKv7fo3w==
=hIhb
-----END PGP SIGNATURE-----

--nextPart3350936.vY14niAmun--
