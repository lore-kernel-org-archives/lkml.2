Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab1DWBgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 21:36:12 -0400
Received: from csamuel.org ([74.50.50.137]:33825 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143Ab1DWBgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 21:36:11 -0400
From: Chris Samuel <chris@csamuel.org>
To: Yuhong Bao <yuhongbao_386@hotmail.com>
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad Pentium Pro system
Date: Sat, 23 Apr 2011 11:35:54 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: alan@lxorguk.ukuu.org.uk, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
References: <201104222333.25546.chris@csamuel.org> <201104231016.23579.chris@csamuel.org> <SNT125-W638277FA9F3B49B316DC9FC3940@phx.gbl>
In-Reply-To: <SNT125-W638277FA9F3B49B316DC9FC3940@phx.gbl>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@
 =?iso-8859-1?q?=5ESdaXtmdYGRq=0A=09=5B?=>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<
 =?iso-8859-1?q?=7Bn8m=3BX=5F=0A=09g=5CY9LQ=3Dv/b5=60?=)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)
 =?iso-8859-1?q?F!1M3=3Dw=3Ai9MsWp=26v=3B=25usOXL=3Bw=0A=096kF=3FwAZjss=2E?=
 =?iso-8859-1?q?+y?=(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1927792.jHLlWlWArj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201104231135.54966.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1927792.jHLlWlWArj
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Apr 2011 11:28:20 AM Yuhong Bao wrote:

> This is a stupid BIOS,

I won't argue with that, it is at least 15 years old..

> but do you know if it used E820 in  the old kernel?

No, it was using E801:

BIOS-provided physical RAM map:
 BIOS-e801: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e801: 0000000000100000 - 0000000010000000 (usable)

The new kernel has the '1' in the top end of the second
part being one place to the right:

BIOS-provided physical RAM map:
 BIOS-e801: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e801: 0000000000100000 - 0000000001000000 (usable)

> I wonder if this has something to do with the changes made
> to support ACPI 3.0 changes to E820?

I suspect not, given it's not using E820. But could be wrong. ;-)

> This would be easy to diagnose with DOS DEBUG with no himem.sys
> loaded.

Would be happy to try with some instructions if it would help.

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1927792.jHLlWlWArj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATbIs+o1yjaOTJg85AQJpEQgAhe8gDHewqazUtzFpF5N25UEAUFBXBWVg
EA2uDfMCWN5/zDmlgeRz22+68zuINQbDeFJnu8N6YmW9I3p8M95nRqzFPVCGeWKU
fIZhXSKWoSNvq7PJnrqlkrWsx/HvQ2ZaUBiQ1mfbekcDw/Ci5gHFLoqKQPEM517B
rB0Qe5JiUNcwQ8ml/ohmWLWyLxHgKzTk5W+oGTGdbHyqJVb/vPVjxwJUigbtbiSe
w1UdflPW6fVfKLpdIKEk0hPExRXYJ5L9IKm8N4tigvq4Fs1gZ6SKblqxBhTFNSEQ
MLSdl4M3sBlP1o2qmQBcN7edhcqMQQRbSLWNjFpGUiK9u5Ypb5ejOg==
=hHwa
-----END PGP SIGNATURE-----

--nextPart1927792.jHLlWlWArj--
