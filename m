Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab1KSEsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:48:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58339 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1KSEsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:48:31 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=h72xEATfbg4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=ankguWfssnWlHO32Y0EA:9 a=QEXdDO2ut3YA:10 a=U62fhAwekXMA:10 a=Gh8-idXl3amKeleTa_cA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111119044510.811163517@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 18 Nov 2011 23:45:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 0/5] [ANNOUNCE] v3.0.9-rt26-rc1
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear RT Folks,

This is the RT stable review cycle. As I am just starting to manage the
3.0-rt stable tree, I'm in the process of creating scripts and such to
send out patches. I will always send out a -rc1 to give people a chance
to yell at me for something stupid I did. It will also allow others
to run this under their own tests as I have a limited testing that I do.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candida=
te).

I will also be updating the git tree on kernel.org with the final release
but the pre releases will not be in the public tree. The final release
will also include the full broken out patches.

to build a 3.0.9-rt26-rc1 tree, the following patches should be applied:

http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.9.xz

http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.9-rt26-rc1=
.patch.xz


You can also build from 3.0.9-rt25 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.9-rt2=
5-rt26-rc1.patch.xz

If all goes well, this patch will be converted to the main release
next Tuesday: 11/22/2011

Enjoy,

-- Steve


John Kacur (2):
      softirq: Export in_serving_softirq()
      rcu: Fix macro substitution for synchronize_rcu_bh() on RT

Peter Zijlstra (1):
      x86: crypto: Reduce preempt disabled regions

Thomas Gleixner (1):
      dm: Make rt aware

----
 arch/x86/crypto/aesni-intel_glue.c |   24 +++++++++++++-----------
 drivers/md/dm.c                    |    4 ++--
 include/linux/rcutree.h            |    2 +-
 kernel/softirq.c                   |    1 +
 4 files changed, 17 insertions(+), 14 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOxzUUAAoJEIy3vGnGbaoAG/MP/RVtai5EO8gWD7BYsXt66tHI
Y8bvyx+L+izp5FkwSRF8urWoe40hqE+Suc0iJ3FvBhb/ZyLeOuhSv7oAHnsmkPCc
AO1QdIOTHR//HWEpiCmF+8jwR32hA/8CUEwsPNcLHP9drAJGVUPsKXs+y8F/2ZlG
JwOjO/q+sEEFYqY58BgTWb0EpfGZTzdfqYfAIlqNmm1ZqOuPANbKtCrWbHIPCYDR
aNgfKd0SMerPnEGuArdLbDKU6OGiF7iTHNPmy1EUFVkbPPMGLRoME3kgfuWPrqes
R6IU2n/Qh5RGyBA7CO0GtpIFxKyPhma0NQaBCb21UCjCmbr6FHpLAhha2yc+OczV
Jr8sMoa0FCMiB7jZgiEXVsUDoUvCaQrg7PkmmtzrJnObn1zQ3wzXRkTMCp0ue3R3
Mh6ZezwAv6eVmLgQsPgjEyPI/gkl/09pDVeRaN38N0ZfeLXDuQVEynnxHtI4g5F+
urnJt1z9+oq/ivfHYH5WLUo+h7P7Zp7JBU22P4b8ICQ3c9De8KtAQ+ksEhTSvgaW
/DneDiObyRD7zW/Lwyh6Dvsw+MVHsHuWMLmAjWu962/8HPXPrfrlFSvu9v1un8Zl
XtQu7YzXFk2OzsF/W0kjvfNen/ipa1bsv+ZkZSyz0rgVzuSEJ11l6lxfyFkQRgk1
2BNa2bBIebzw+BRAZEI3
=ZiNk
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
