Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab0DWKuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:50:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54808 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab0DWKuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:50:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CisdBKRoRVANY0nQ/Z3pc/+SD/Xu4swspaqFsR8Nz9xSWU2P51cdlF8aL/EttnomaP
         cZnXbSaAqtV3F/jx4H1oxJhCNVXgPCqf8V7LYxWzlzWaR4ZVErNzM4exCSMc5A8wNKdt
         nPQg+XXMxULxT2K/NfrfQ/eeQkJ5+dNgwJ0Fw=
Date: Fri, 23 Apr 2010 13:51:28 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: suppress warning: =?utf-8?B?4oCYcXVv?=
	=?utf-8?Q?tatypes=E2=80=99?= defined but not used
Message-ID: <20100423105128.GC3293@swordfish.minsk.epam.com>
References: <20100422080540.GA3286@swordfish.minsk.epam.com>
 <20100422193148.GG5805@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DSayHWYpDlRfCAAQ"
Content-Disposition: inline
In-Reply-To: <20100422193148.GG5805@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DSayHWYpDlRfCAAQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
On (04/22/10 21:31), Jan Kara wrote:
> The patch is fine. Could you please add your Signed-off-by to the patch
> (see Documentation/SubmittingPatches in case you don't know what it is).
> Thanks.
>=20
> 								Honza
My editor truncated /* List of registered formats */ line in the patch. So
I resent it (titled as (resent)). Sorry for inattention.


	Sergey

--DSayHWYpDlRfCAAQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkvRe7AACgkQfKHnntdSXjRdvAP/QuhxxnIPL7bqZ+TKstzjZoDw
aHRHe4BO48nGhH6kJB4Lery4iZUTEb2llMf5iMluV7yKl6V2PHPuBUchOxCLQxXt
QmARVohaZ/t7x+AuASVskzYlzMotOcHUY9C0eMjjd65n3q3X5JGuB1pQ3J4A0P04
/hCDJ2JA50olP26+JGg=
=a2XX
-----END PGP SIGNATURE-----

--DSayHWYpDlRfCAAQ--
