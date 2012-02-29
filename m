Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab2B2LdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 06:33:00 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55315 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab2B2Lc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 06:32:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dedekind1@gmail.com designates 10.50.47.198 as permitted sender) smtp.mail=dedekind1@gmail.com; dkim=pass header.i=dedekind1@gmail.com
Message-ID: <1330515322.3545.99.camel@sauron.fi.intel.com>
Subject: Re: [RFC][PATCH 0/7] UBI checkpointing support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <rw@linutronix.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tim.bird@am.sony.com
Date: Wed, 29 Feb 2012 13:35:22 +0200
In-Reply-To: <1329250006-22944-1-git-send-email-rw@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-DVUi3Z9fm01y1yUIqiZO"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DVUi3Z9fm01y1yUIqiZO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-02-14 at 21:06 +0100, Richard Weinberger wrote:
> The following patch set implements checkpointing support for
> UBI. Checkpointing is an optional feature which stores the physical to
> logical eraseblock relations in a checkpointing superblock to reduce
> the initialization time of UBI. The current init time of UBI is
> proportional to the number of physical erase blocks on the FLASH
> device. With checkpointing enabled the scan time is limited to a fixed
> number of blocks.

Notice, your patch-set has huge amount of checkpatch.pl complaints -
please fix them. This will also be consistent with the overall UBI
coding style where I honored checkpatch.pl limitations like identation
style and 80 chars per line.


--=20
Best Regards,
Artem Bityutskiy

--=-DVUi3Z9fm01y1yUIqiZO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPTg16AAoJECmIfjd9wqK0lR0P/2cptfpDgeVPBtkcmSAmV1eX
dxNSLbIGoareryN8whU2jWLnbXt/xqiKYNFDRXlQnUS6Lndk44qMa0xT7mUTvlqN
6AXHUYxMrkhPeiDzh9/L4Lpdp5kTx9EHgqhMQhGglvSoB8HJy3TKqtxS1AbhZ9hi
HyI0mk94VNXkya/nZ88vNhIYQ9vH4khzbRwGemHJ7XK107XQU5tFfOmiQr5tlDx8
sYKpRvB7rA3/EMz6ylETDqdZWzDmRRLX+qcP0fnSY8zXfIhh1QIIsREjJ0NRxFvz
uAWbnGloy6GBbzHDu8oz8GmSKei+wu8730Onx/EH/YkUbYYuc3aX8YadhOekgBUb
T6KWvtSph5TBO4AnX+76TmvjNw/hEA105F0XP2Iz84y1xlpjJLr2jwvSf6qDZpvv
hlu591ET2awlUolLs489jHoUeXQ2oxjsTM2tY6BSVcohIvlwRV+km4VTvMa8vti4
R+7ON7j3jVYvFQGhpAWPxPdtI146dt6nLP87ZlK3FZhTZV+C+1XTBPXwNZt609T3
MlWBMlGhG00YujgDD0Gh5z9G26qkVpatSTiJsKzZ47DvFjVFvGwio/4lIOsCmODo
/fx5rh/3ngsHHmQtVgsEDHt1u6VEW3ihRRErB0gT2vg/cjPUR0EKmz2wi9HZZp2w
eInvuE+Sgy0SnUtQcwsa
=NuyQ
-----END PGP SIGNATURE-----

--=-DVUi3Z9fm01y1yUIqiZO--

