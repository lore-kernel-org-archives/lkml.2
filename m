Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab1GYUDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:03:39 -0400
Received: from home.keithp.com ([63.227.221.253]:40150 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab1GYUDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:03:38 -0400
From: Keith Packard <keithp@keithp.com>
To: "Guy\, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iwlagn: check for !priv->txq in iwlagn_wait_tx_queue_empty
In-Reply-To: <1311621715.5579.138.camel@wwguy-huron>
References: <1311622702-4807-1-git-send-email-keithp@keithp.com> <1311621715.5579.138.camel@wwguy-huron>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 25 Jul 2011 13:03:34 -0700
Message-ID: <yunvcuqunzd.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jul 2011 12:21:55 -0700, "Guy, Wey-Yi" <wey-yi.w.guy@intel.com> =
wrote:

> but why you need it?, "start device" call will fail if can not allocate
> priv->txq

The device is down, so start_device was never called. At least, that's
my assumption -- I've got the wireless device 'disabled' in
NetworkManager.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOLcwWQp8BWwlsTdMRAgWeAKDA0nKhnHURsbVvBpxJS5aF6NsUEACg5wV7
Ed0/dTKJfhRfnWGNoFYAip4=
=Q13b
-----END PGP SIGNATURE-----
--=-=-=--
