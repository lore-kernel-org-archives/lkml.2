Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934138Ab2KBSCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:02:03 -0400
Received: from narfation.org ([79.140.41.39]:54632 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452Ab2KBSCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:02:01 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2012 14:02:01 EDT
From: Sven Eckelmann <sven@narfation.org>
To: b.a.t.m.a.n@lists.open-mesh.org
Cc: Shan Wei <shanwei88@gmail.com>, lindner_marek@yahoo.de,
        siwu@hrz.tu-chemnitz.de, ordex@autistici.org,
        David Miller <davem@davemloft.net>, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [B.A.T.M.A.N.] [PATCH v2 9/9] net: batman-adv: use per_cpu_add helper
Date: Fri, 02 Nov 2012 18:55:21 +0100
Message-ID: <5905519.yWN2Ke3YlE@bentobox>
User-Agent: KMail/4.8.4 (Linux/3.2.0-3-amd64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <5093EE7E.6040400@gmail.com>
References: <5093EE7E.6040400@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3842683.NmRLt5WN2J"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3842683.NmRLt5WN2J
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Saturday 03 November 2012 00:02:06 Shan Wei wrote:
> From: Shan Wei <davidshan@tencent.com>
> 
> As Christoph Lameter said:
> > In addition, following usage of per_cpu_ptr can be replaced by
> > this_cpu_read.
> > 
> > cpu=get_cpu()
> > ....
> > *per_cpu_ptr(p,cpu)
> > ....
> > ....
> > put_cpu()
> 
> Right.
> 
> Signed-off-by: Shan Wei <davidshan@tencent.com>
> ---

Is this really supposed to be the commit message?

Kind regards,
	Sven
--nextPart3842683.NmRLt5WN2J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQlAkKAAoJEF2HCgfBJntGs2EQAJVHCL0sb6v7CpICRpuh8CT+
XytktNVJdL65e9O7NN+wwen//Va33rpAHtePk7xmPaJUl1Dp9ao++6EjDSljU1cE
y7XRVz1O4m1d+hG3cFvQt+H8rQ6Nm5SNBLiDu06rIYglMqf21mKrVBjoHSEKaBWt
mHpwabItaTore4GdV293AbvHI/5VwqP5nmFrgZoV7b+EF2WSBn7Dl2aweGKJUcC6
QbGOYJTQkXRBPetLgfbBxiisZDlrJfkwmZSmDtFx5R74L/TMsFg6NDaIlZM//vNp
CtU32RnUInSM9iav+Sv2knDuiDEzr2PyNw4393ADhEcQorK/luh7S/EV+DBiMh4V
AxVU9CreeWCKjlP5r/5/3E6znt5x8SkyEDWsAYg8GaRfmmUBdL2CqA/9phm4omYB
rRhgaaXuCd65G3GCwDNjzkrql6FMvK3AgMqS1qQ/OBHhq3TL0p9Oe8vZboadRLdP
h3tonwDQOnBFKceAvRzRd7n9vCkcnkGPRgTA7RmeCV6S1qgPyaQryzw+nBkw5/C6
1DZqTkpPxqdOn+uRC4yP7LS7HVAxgNC1NC6v65yN/wjeLuz+KtpXEIDX5lFWRoe4
LJ47KLWnBhbIHCIs1qbDPS0Nq+tMZhpxAzB8GpH9zUeQZ+5mo49OAaWOioEociyW
MVx7xTIxaw/+t+Kb+9jk
=DjCC
-----END PGP SIGNATURE-----

--nextPart3842683.NmRLt5WN2J--

