Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2JCJax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:30:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:3514 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab2JCJaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:30:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,527,1344236400"; 
   d="asc'?scan'208";a="229935861"
Message-ID: <1349256659.2017.128.camel@sauron.fi.intel.com>
Subject: Re: UBI: Fastmap request for inclusion (v19)
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Richard Weinberger <richard@nod.at>
Cc: Heinz.Egger@linutronix.de, tglx@linutronix.de,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tim.bird@am.sony.com
Date: Wed, 03 Oct 2012 12:30:59 +0300
In-Reply-To: <506BFF58.4060106@nod.at>
References: <1348674710-102885-1-git-send-email-richard@nod.at>
	  <1349252745.2017.120.camel@sauron.fi.intel.com>
	  <20121003103625.0bbff63c@spider.haslach.nod.at>
	 <1349253885.2017.125.camel@sauron.fi.intel.com> <506BFF58.4060106@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-aU+rnHgRHL/dGShmrNMe"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aU+rnHgRHL/dGShmrNMe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-10-03 at 11:03 +0200, Richard Weinberger wrote:
> Yeah, it looks like all issues reported by aiaiai are caused by the missi=
ng goto.
> Can you deal with the patch below or do you want me to send it using git =
send-email?

I'll apply it. But please, re-work the error handling in that function
separately.

--=20
Best Regards,
Artem Bityutskiy

--=-aU+rnHgRHL/dGShmrNMe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQbAXTAAoJECmIfjd9wqK0oTYP/26+PBm9PMNfKA7mmbpKwhaF
DNaEhZy3XhgDo5fobbkKNRI45hIYCiJu01LMN2qMJ6QaQCg4akjvXO/k2hM8j5pE
RJwrrUjO0awkOHsJ+l2M77FgWqOyJlFVIRbN3g9nvV2ygs+rjCRR/qYItb3kfvc8
FzC7WQzZyDn3jBOgvoBrIqI8o64rlJxgyGwy2jHujI3sEOEXf0O2KX+U0jTPIjzL
KE9odHB37+V9EN2eI09i6Ij8ReCPkQiv3xzohHd6WfxR5EfR+68WHsv6jY0007o2
cJ3wc4KI0U4fZTR6yaCdsq4YzvA4LP/7MbDKuHZVb+/cYfBvh9ygZpa8LAH9jGQK
MTCcPcbbzCWz4lp3qabubgYodzFx5+HSgULwS9qEQ/tlu6vNy3sab6Xn420CaC8S
5qj3UreOuv6PB87luIbQ5F1vl2VMs1vI5IdxX1h0TjXC/CQXSVH2X5bQtkHgkhey
n7cf3yg1vIkUaqcXotKNUQMmp+pP4oyxx81myiimD0Xo+E6X4J3/lMMQu/A8EGwY
60JKCg/2Oj+q+Gy1GEH3KSqOwQtTucVK26K7GGl57RlaNGs6YijnQNPjw6tLYJ7M
8IzrOcPuLBh9ILLtT3HHf9g578XGSkTKxbxhZhyM2ugV+o6FGP+D9ZzPxUTDMFFn
LeBbV86Ed0BaOYCfzQFV
=t4MI
-----END PGP SIGNATURE-----

--=-aU+rnHgRHL/dGShmrNMe--

