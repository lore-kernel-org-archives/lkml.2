Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1DZEud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 00:50:33 -0400
Received: from csamuel.org ([74.50.50.137]:53891 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab1DZEub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 00:50:31 -0400
From: Chris Samuel <chris@csamuel.org>
To: mingo@redhat.com, hpa@zytor.com, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Subject: Re: [tip:x86/urgent] x86, setup: When probing memory with e801, use ax/bx as a pair
Date: Tue, 26 Apr 2011 14:50:09 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: linux-tip-commits@vger.kernel.org
References: <1303566747.12067.10.camel@localhost.localdomain> <tip-39b68976ac653cfdc7f872a293e8b7928de2dcc6@git.kernel.org>
In-Reply-To: <tip-39b68976ac653cfdc7f872a293e8b7928de2dcc6@git.kernel.org>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@^SdaXtmdYGRq
	[>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<{n8m;X_
	g\Y9LQ=v/b5`)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)F!1M3=w:i9MsWp&v;%usOXL;w
	6kF?wAZjss.+y(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart26081061.b9chhiMscQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201104261450.15786.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart26081061.b9chhiMscQ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Apr 2011 09:25:02 AM tip-bot for H. Peter Anvin wrote:

> x86, setup: When probing memory with e801, use ax/bx as a pair

ACK. Thanks!

=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart26081061.b9chhiMscQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATbZPAo1yjaOTJg85AQLu0gf/YNGTSCOTxtQ6+VHpABbtyKWWMGy0Zf+v
dsiQa3NTfOFVam+bO/50gBjG1plbjCYJm9dvDiFn40JnBXf0CvjotK3KR8Dc4lcQ
acSgjVSlA83IQPtwU0yEfr4piW/0opCf6CEz4CIBzbhFfNjRnaNGmhDW6+QViFVr
CPtEbsGNlE1UAZXPQrNurGPB7VrDv4VVdtdcAhnySyhMqHOL9dA+XBsKtA1AX++l
owZBbmtA/9hpsXHO1U9JNhIrc4ffAvEmOSUgIZDzxO1070HhVzhWrFft+wN3RxjX
MoIcktGUDRw57RlTVyAv9OmvTnyThUCezEJtxZlGBh1v3AWEQ7JTcw==
=jN75
-----END PGP SIGNATURE-----

--nextPart26081061.b9chhiMscQ--
