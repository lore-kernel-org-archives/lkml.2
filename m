Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1BNNxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:53:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40131 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab1BNNxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:53:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RYW8PJ12GsQX8Wre1Dew/yjxjHp5tgXunaa51VUSgJnOKICUMpkiGpwjOZTJ7H7076
         E+7N1SfFlKaykKzA5vuOOJWMuHdBoNUiBozPj3aXAEY8PbqMZME5atexVZPwG3PZYvGz
         PSiAlRslFam/shN/1iYB4tZYRUq/0vI71aPV4=
Date: Mon, 14 Feb 2011 15:52:17 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, Tejun Heo <tj@kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix section mismatch in reference from
 native_play_dead
Message-ID: <20110214135217.GB4586@swordfish.minsk.epam.com>
References: <20110203131333.GA4161@swordfish.minsk.epam.com>
 <20110214122550.GA15860@elte.hu>
 <20110214123244.GA4586@swordfish.minsk.epam.com>
 <20110214133210.GC9137@aftab>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
In-Reply-To: <20110214133210.GC9137@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (02/14/11 14:32), Borislav Petkov wrote:
> Right, but mwait_usable() is not __cpuinit anymore and __cpuinit
> functions should be able to call other functions without annotation,
> methinks, no?
>=20

Right,
Agreed, Borislav's fix is the correct one.

Thanks,
	Sergey

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk1ZM5EACgkQfKHnntdSXjTQVwP9FT243UKuCaeeQq2dEV3qAXH8
s+iZm/iDDyJy+YQ81lrqP3vJSG2ca8LEGh4VmCJrObcni25XHDxL5GoxSDAaxJ/Z
NOkayBCnZeZWmu0eQE9fXYkW1YH7w8t69xa6/cEsTPlVbNtCtjbLpV7LjIhdmSyv
kGSd2HDzfM/Ym1xECE4=
=Zomv
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
