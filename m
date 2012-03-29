Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab2C2Avf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 20:51:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53710 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210Ab2C2Ava (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 20:51:30 -0400
Date: Thu, 29 Mar 2012 11:51:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Przemo Firszt <przemo@firszt.eu>
Subject: linux-next: build warning after merge of the hid tree
Message-Id: <20120329115117.70e8660dbd0c73354486eba9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Mar_2012_11_51_17_+1100_pSTJ.lilrThePGqA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Mar_2012_11_51_17_+1100_pSTJ.lilrThePGqA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

After merging the hid tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/hid/Kconfig:595:error: recursive dependency detected!
drivers/hid/Kconfig:595:	symbol HID_WACOM depends on HID_WACOM

Caused (very obviously) by commit 224b321b312e ("HID: wacom: Remove
CONFIG_HID_WACOM_POWER_SUPPLY option").

Please test this stuff.  And don't rush stuff in during the merge window ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__29_Mar_2012_11_51_17_+1100_pSTJ.lilrThePGqA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPc7IFAAoJEECxmPOUX5FE6SwQAKi+SWrXD+14HqmJ7d4ax/Va
nim6zHdX72LxxKOiJpz85Wb98brDFTPoi9mNLyQ+LZBBUDYOyc2W8dc8vPP76toy
up8MeZwQq2hY4KeSYuXLyriNRsYhYYDYryRO61fmc2H6/C4kwIdT17dRobf/lLY8
Rm0ZrFFWfQJULEZXAIbS4n0zIqscJr9yOiEIT/ZFMd6yWWm/j5dD7E4yetLS5lJ7
cI7wsiWTooWM4zWUykxiwarJrlfGP/IYwkstvKLqi3reUHIzZ2dYmTXFIORya5hX
bkNjLWOlzYubojsa32Z+0mfyVgT4kgm/tjY4+U9afm+R4q0LaqtdCPpCe8kFMo+4
3WPK3vOfj0oPqK2VMerTvXAW1tX732Ui+50b+2koLFHjkIc9W0OASH36HiZWqizF
3a6a9Xw9T6qX8ZepAWWIiG+7CM+K8/31w2WU1zfFmLTXIGu+sZppyKKQZFLLCsa3
ZiFIbu830uIG/9KP6Gsl/x40+383iLSck8tFMa4GLMh0EZKG7yDgngAyRthLrxoB
btdyS/0hJ9Z1mX5Xx0GUO3T+yrJOYf/t7tjlMdlyqfu8CMfJbZV0oRBLzc9Z6zTP
xAweamhn3WKuz8qf0R6E90Phn1YOqz+3Er3ljHaYRQScqicLMy6c3si+jduBzSGa
/idHLx9Ntct3UkxOcWHb
=Tp2x
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Mar_2012_11_51_17_+1100_pSTJ.lilrThePGqA--
