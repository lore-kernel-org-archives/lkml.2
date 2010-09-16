Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab0IPSnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:43:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64286 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab0IPSnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=tKvi4Z73o/Z/1AkmHRUDFI/638GymEoFtakXfAjprFeClz28wZOThy85fnwZFg+xUy
         YofzBPXg0qpoZoQhEvyxxbOAPVX+kxYLpCZBWw6mN0XptzmMd6dkz0ZFGHXkmGOdzWRC
         urBK00s4YRXR5Af6bMmuprnvrbKiiQ4ZTBTKE=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Interrupt latency on some 945GM platforms
Date: Thu, 16 Sep 2010 21:42:05 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-git2-anarsoul; KDE/4.5.1; i686; ; )
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <201009132336.17310.anarsoul@gmail.com> <alpine.LFD.2.00.1009162004500.2416@localhost6.localdomain6> <201009162131.03365.anarsoul@gmail.com>
In-Reply-To: <201009162131.03365.anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1534486.yGN2csEm2K";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009162142.10629.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1534486.yGN2csEm2K
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: base64

0JIg0YHQvtC+0LHRidC10L3QuNC4INC+0YIgMTYgb2YgU2VwdGVtYmVyIDIwMTAgMjE6MzA6NTgg
0LDQstGC0L7RgCBWYXNpbHkgS2hvcnV6aGljayDQvdCw0L/QuNGB0LDQuzoKPiDQkiDRgdC+0L7Q
sdGJ0LXQvdC40Lgg0L7RgiAxNiBvZiBTZXB0ZW1iZXIgMjAxMCAyMTowNzozOSDQsNCy0YLQvtGA
IFRob21hcyBHbGVpeG5lciDQvdCw0L/QuNGB0LDQuzoKPiA+ID4gQnR3LCBKZXNzZSwgYW55IGNv
bW1lbnRzL3NvbHV0aW9ucy93b3JrYXJvdW5kcyBleGNlcHQgb25lIHdpdGgKPiA+ID4gcHJvY2Vz
c29yLm1heF9jc3RhdGU9MSBpbiBrZXJuZWwgY29tbWFuZGxpbmU/IFNob3VsZCBJIGZpbGUgYSBi
dWcgb24KPiA+ID4gZmRvIGJ1Z3ppbGxhPwo+ID4gCj4gPiB3ZSBmaXhlZCBhIEhQRVQgcmVsYXRl
ZCBidWcgYSBmZXcgZGF5cyBhZ28sIHdoaWNoIG1pZ2h0IGJlIHRoZSBjYXVzZQo+ID4gZm9yIHlv
dXIgcHJvYmxlbSBhcyB3ZWxsLgo+IAo+IE5vcGUsIGl0IGRvZXNuJ3QgaGVscCA6KAoKQnR3LCBJ
IHN1c3BlY3QgaHBldCBpcyBub3QgcmVsYXRlZCwgSSBkaXNhYmxlZCBocGV0IGNvbXBsZXRlbHkg
aW4ga2VybmVsIApjb25maWcgYnV0IGlzc3VlIGlzIHN0aWxsIGhlcmUgKGNsb2Nrc291cmNlIGlz
IGFjcGlfcG0pCgpSZWdhcmRzClZhc2lseQo=

--nextPart1534486.yGN2csEm2K
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkySZQIACgkQRM6pQpltKE7yOgCdEgm3MUUCvMy3TYKPq6YDtfYI
oCMAoMYaMWbEe1lVql2TGSSG3Gpe2lmK
=L1qx
-----END PGP SIGNATURE-----

--nextPart1534486.yGN2csEm2K--
