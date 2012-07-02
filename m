Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab2GBCOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 22:14:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60287 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab2GBCOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 22:14:35 -0400
Date: Mon, 2 Jul 2012 12:14:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the hid tree
Message-Id: <20120702121431.bf4119857a91068f395bcd21@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Jul_2012_12_14_31_+1000_NJfnn/VUqioV7561"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Jul_2012_12_14_31_+1000_NJfnn/VUqioV7561
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

After merging the hid tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/hid/Kconfig:7:error: recursive dependency detected!
drivers/hid/Kconfig:7:	symbol HID is selected by USB_HID
drivers/hid/usbhid/Kconfig:4:	symbol USB_HID depends on HID

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__2_Jul_2012_12_14_31_+1000_NJfnn/VUqioV7561
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8QQHAAoJEECxmPOUX5FEOTgP/ivYiU2seWk9fNXZFnbzL7b4
7BxJ9vO/BIJWOq+/0xNdwIoIQmlLNc7ZSkJkAptf7ub9k33udIuPnKgrc10IyI3R
DDXfJItLJP/T7zV3tX+Fs7fH43Ceq0CLwAUiIA6XkrvRCk7uuOML1mKsMCbSm302
6sernf++Nz9g4c7D5sZaDfx3ybxrMnxMschrTx77vRY56KjxKOnbdsScRkAhWb6u
XKvfRkR+2FxGReNmLhqNM64yeNbvh0gnWlgnj8VRNzwyazjqslOaWbOzDFz6uzsp
IlKzBjZeITa1o2qwvi8tFfmo5KyaDLJbdHjNSwUr3vjjTqxvCrpuYxNn+jey5FTS
EnAKUBG7kwl3NaE1XarntF2xW8qtpHZGbj82pT4S67nLJL6oHL22g8ExkrIW9MnM
WRSnHv74sKSSj4lc06GQVkpDMBhM6yvYwS+o5Nyeb8x0O4sgFXc8P/4xUFWe2S4K
rkyq4ThNrcJCO+3BTK8Q51tifOAGB1rgpMp/Y+iouWPMY5HubWEUsipIqcQT29GA
cIV0QSc7QTJQLQeebXHrfMS590IMXZZtOxER77G22vwmMpNFIkoWY2Gj/C6H7Gg7
Z62UBstD9ylNy8O8Axg0HS0BdwsxZzg3klgghPaj5UoW8+Y3VfZ2G6cBy5qCBcgl
8PHz0Bf8SCH80zgQeadx
=T5nn
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Jul_2012_12_14_31_+1000_NJfnn/VUqioV7561--
