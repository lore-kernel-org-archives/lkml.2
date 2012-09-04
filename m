Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab2IDPHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:07:51 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:49249 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2IDPHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:07:49 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 11:07:49 EDT
Date: Tue, 4 Sep 2012 15:01:07 +0000 (UTC)
From: Paul Walmsley <paul@booyaka.com>
To: Jiri Kosina <jkosina@suse.cz>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] HID: remove Paul Walmsley's copyright from places
 where it shouldn't be
In-Reply-To: <alpine.LNX.2.00.1209041326420.23857@pobox.suse.cz>
Message-ID: <alpine.DEB.2.00.1209041458550.11437@utopia.booyaka.com>
References: <alpine.LNX.2.00.1209041326420.23857@pobox.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-726100372-1346770867=:11437"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-726100372-1346770867=:11437
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello Ji=F8=ED,

On Tue, 4 Sep 2012, Jiri Kosina wrote:

> Paul Walmsley has implemented dynamic quirk handling back in 2007 through=
=20
> commits:
>=20
> 2eb5dc30eb ("USB HID: encapsulate quirk handling into hid-quirks.c")
> 8222fbe67c ("USB HID: clarify static quirk handling as squirks")
> 8cef908235 ("USB HID: add support for dynamically-created quirks")
> 876b9276b9 ("USB HID: add 'quirks' module parameter")
>=20
> and as such, his copyright rightly belongs to=20
> drivers/hid/usbhid/hid-quirks.c file.
>=20
> However when generic HID code has been converted to bus and individual=20
> quirks separated out to individual drivers on the bus, the copyright has=
=20
> been blindly transfered into all the tiny drivers, which actually don't=
=20
> contain any of Pauls' copyrighted code.
>=20
> Remove the copyright from those sub-drivers.
>=20
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>=20
> Paul,
>=20
> I am sending this out to you as RFC, and am not willing to apply it=20
> without your explicit Ack.

Looks fine to me, thanks.

Acked-by: Paul Walmsley <paul@pwsan.com>

- Paul
--843723315-726100372-1346770867=:11437--
