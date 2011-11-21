Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab1KUVry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:47:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60175 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab1KUVrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:47:53 -0500
X-Authority-Analysis: v=2.0 cv=NJxXCjGg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=-NRwE79F_FMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=t2u7cxE38oL5wYNR_OwA:9 a=dS39hvG6TbENLXICLYYA:7 a=QEXdDO2ut3YA:10 a=U62fhAwekXMA:10 a=9X4vmcykiGSDxPJ1zMAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111121214420.124907956@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 16:44:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 0/6] [ANNOUNCE] v3.0.9-rt26-rc2
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
a new release is out. This is just a review release (or release candidate).

I will also be updating the git tree on kernel.org with the final release
but the pre releases will not be in the public tree. The final release
will also include the full broken out patches.

to build a 3.0.9-rt26-rc2 tree, the following patches should be applied:

http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.9.xz

http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.9-rt26-rc2=
.patch.xz


You can also build from 3.0.9-rt25 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.9-rt2=
5-rt26-rc2.patch.xz

If all goes well, this patch will be converted to the main release
next Tuesday: 11/22/2011

The differences between -rc1 and -rc2 is:

Added two Reviewed-by tags from Paul McKenney.

Added the tracing patch that was added in v3.2-rc2-rt3

Enjoy,

-- Steve

John Kacur (2):
      softirq: Export in_serving_softirq()
      rcu: Fix macro substitution for synchronize_rcu_bh() on RT

Peter Zijlstra (1):
      x86: crypto: Reduce preempt disabled regions

Steven Rostedt (2):
      tracing: Show padding as unsigned short
      Linux 3.0.9-rt26-rc2

Thomas Gleixner (1):
      dm: Make rt aware

----
 arch/x86/crypto/aesni-intel_glue.c |   24 +++++++++++++-----------
 drivers/md/dm.c                    |    4 ++--
 include/linux/rcutree.h            |    2 +-
 kernel/softirq.c                   |    1 +
 kernel/trace/trace_events.c        |    2 +-
 localversion-rt                    |    2 +-
 6 files changed, 19 insertions(+), 16 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOyscBAAoJEIy3vGnGbaoAzksQAI91WAPAWURKRAafZj1bRt/u
6TKTO2X+YleYrFwp1K7sSQrtja8kUeUO8OD5L9ka0R4JIDyb2BGLQFgMtb29Dw53
eqiGi6FoXZqCQ2U/5BvTmLFIcL+MfU2v3chFRrDaXpxNzfUKgh0mj8WrKSK6/Lle
kORcqOOhaqHhluW2Zeqy7P6apQdBHhPKVGFBYNNWNS3Z5+VJxEm41V4q9D2X87B7
kC9nQeTzY9YnfxF+matV11l8DTSXd1A5dOZoJp2KGjhS8v8SwaHWopFOwvT+/Lov
Ji9mODC/6PXZNi3yakAG/ak+PP2ogxSlCDs+agynau9LImeTyaY+7vmXbwfAVbmX
K8Lf44mpL9W8sQ603Q1vRUMnk8GN64zk2dco+tDz6jhN8p2iw+GOnJdsU0B5kL6s
bc9McaFrEYUgPTRDQF/iXEjzOF+rLb7K70WOjErNUQIo2UUcMqpUR7SSkYOn2iOh
p5nDeTpt132ZJ0f+5S4m4wRRj4robjSAsNbkOMMdi4+wjvx3b/ubErkBcBS3uKI5
EpFi2e8IW97swDjWA73zzJxcx8nXrzmeVHJY1eEsuzBeybSb+zsqBFehg4hY7KEd
C2Kl5U6Joc79HzUokmVb5TfAHZUwAyWYIFoTVwMEhNL551tpcbf2zWuZkuspIbp0
+pm86/4TYbCYOA19y0Kd
=N+ro
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
