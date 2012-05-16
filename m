Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966726Ab2EPJic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 05:38:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:22452 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966479Ab2EPJia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 05:38:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="143826122"
Message-ID: <1337161320.24809.39.camel@sauron.fi.intel.com>
Subject: Re: [RFC v4] UBI: Fastmap support (aka checkpointing)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Date: Wed, 16 May 2012 12:42:00 +0300
In-Reply-To: <1337161096.24809.36.camel@sauron.fi.intel.com>
References: <1337101871-31181-1-git-send-email-richard@nod.at>
	 <1337161096.24809.36.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-r6FXQVVBnlQbJbgmVF+3"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-r6FXQVVBnlQbJbgmVF+3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-16 at 12:38 +0300, Artem Bityutskiy wrote:
> O(N) would be: N -> inf, UBI_FM_MAX_BLOCKS -> C, where C is a constant.

O(1) of course, sorry.

--=20
Best Regards,
Artem Bityutskiy

--=-r6FXQVVBnlQbJbgmVF+3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPs3ZoAAoJECmIfjd9wqK0e0YQAIF05aS8jKIA3quc4mbYnX+G
bViuhs6QFkjZQCv7uwXozkpwdihwqitZdCfzBVFQBB8O8CiQKbCwPWj7Kjbu47M3
tvC93pmNsN31zptJt32lrac1Qr6bq7H9TPK6QVpvWvY02oG8tjCSTDI2g0cprvqJ
idD2xWK9Aj+qfwY7WjBYd6KhvsoBKB+VyAWZnlvw7x4w5B+QpHczcMpoH0yYxd11
n+zCMnQQsT84rUnpys2Y7SByxzzI7xzE59FxcAVMju8+rb8zwmdiGgLK7OunUV1C
8oS713Hjjhz9kF4hq3GzeClhQNMCoJlZbtYeL0DjUHmoj9NogkYu5ttbrjUCAJHn
8qox4Vk0V7adr7qhShJa7MwKtKgYJIk/teQHL8QYoF5PpSvJqeq9mcvarhvVdzkg
lZEmbmQeOFYNwBCzNyX+V7eu00UzUU9wnsQgWajqVMKTKUx0+wgOGWtwgQKgFsKN
Bq6VtcDkEfJI7p7WfEBNr85/F1YZfqfgxqZA/k1kMoVcV0MMQAdcoaAQkWLryPWD
g24+4LauFH5tVBhaSZIpvC75uR8cVLWBygXxEXnDF46Qo6Jg8jk2/3uBwj9G6d15
aFQVmDgb004usN6lNY06Hu5PV8YdJAuUOGyIclcleIDSii16ZEDH0n6+TVhZK7CG
feqskD64sY7KROdaGrvj
=aLRG
-----END PGP SIGNATURE-----

--=-r6FXQVVBnlQbJbgmVF+3--

