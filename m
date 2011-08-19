Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1HSG5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 02:57:24 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:34001 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1HSG5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 02:57:23 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Aug 2011 02:57:22 EDT
From: Ian Campbell <ijc@hellion.org.uk>
To: Corentin Chary <corentincj@iksaif.net>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Dick Streefland <dick@streefland.net>,
        WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <1313484365-22129-1-git-send-email-corentincj@iksaif.net>
References: <1312465977-12388-1-git-send-email-corentin.chary@gmail.com>
	 <1313484365-22129-1-git-send-email-corentincj@iksaif.net>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-pnSvMQgPU58LpjdBxxCb"
Date: Fri, 19 Aug 2011 07:51:26 +0100
Message-ID: <1313736686.17978.15.camel@dagon.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 192.168.1.7
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH v3] scripts: add extract-vmlinux
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pnSvMQgPU58LpjdBxxCb
Content-Type: multipart/mixed; boundary="=-birJsHmBodBQWcJqroMK"


--=-birJsHmBodBQWcJqroMK
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-08-16 at 10:46 +0200, Corentin Chary wrote:
> This script can be used to extract vmlinux from a compressed
> kernel image (bzImage, etc..). It's inspired from (a subset of)
> extract-ikconfig.

FWIW I wrote the attached way back when, it uses the payload_* fields in
the bzImage to find the payload rather than scanning (these are present
in bzImages from somewhere in the mid 2.6.2x range). I'd be happy to
license it under the GPLv2 if that is helpful.

> It's something a lot of people have been looking for (mainly
> people with xen < 4 that doesn't support bzImages at all).

xen 3.4 does, doesn't it (at least the tip of 3.4-testing.hg does)? And
I thought e.g. RHEL5 (which uses an older base version) had it
backported. Possibly what is missing is support for all the various
compression options.

Ian.
--=20
Ian Campbell


How do I get HOME?

--=-birJsHmBodBQWcJqroMK
Content-Disposition: attachment; filename="bzexplode.c"
Content-Type: text/x-csrc; name="bzexplode.c"; charset="ISO-8859-1"
Content-Transfer-Encoding: base64

I2luY2x1ZGUgPHN0ZGlvLmg+DQojaW5jbHVkZSA8ZmNudGwuaD4NCiNpbmNsdWRlIDxzdGRpbnQu
aD4NCiNpbmNsdWRlIDx1bmlzdGQuaD4NCg0KI2luY2x1ZGUgPGludHR5cGVzLmg+DQoNCiNpbmNs
dWRlIDxlcnIuaD4NCg0KI2luY2x1ZGUgPHN5cy90eXBlcy5oPg0KI2luY2x1ZGUgPHN5cy9tbWFu
Lmg+DQojaW5jbHVkZSA8c3lzL3N0YXQuaD4NCg0KaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiph
cmd2KQ0Kew0KCWludCBmZDsNCglzdHJ1Y3Qgc3RhdCBzYjsNCgl2b2lkICpwOw0KCXVpbnQ4X3Qg
KmhkcjsNCglpbnQgc2V0dXBfc2VjdG9yczsNCgl1aW50MzJfdCBjb21wcmVzc2VkX3BheWxvYWRf
b2Zmc2V0Ow0KCXVpbnQzMl90IGNvbXByZXNzZWRfcGF5bG9hZF9sZW5ndGg7DQoNCglpZiAoYXJn
YyAhPSAyKQ0KCQllcnJ4KDEsICJ1c2FnZTogYnpleHBsb2RlIDxiekltYWdlPiIpOw0KDQoJZmQg
PSBvcGVuKGFyZ3ZbMV0sIE9fUkRPTkxZKTsNCglpZiAoZmQgPCAwKQ0KCQllcnIoMSwgIm9wZW4i
KTsNCg0KCWlmIChmc3RhdChmZCwgJnNiKSA8IDApDQoJCWVycigxLCAiZnN0YXQiKTsNCg0KCXAg
PSBtbWFwKDAsIHNiLnN0X3NpemUsIFBST1RfUkVBRCwgTUFQX1NIQVJFRCwgZmQsIDApOw0KCWlm
IChwID09IE1BUF9GQUlMRUQpDQoJCWVycigxLCAibW1hcCIpOw0KDQoJaGRyID0gcDsNCglzZXR1
cF9zZWN0b3JzID0gaGRyWzB4MWYxXTsNCgljb21wcmVzc2VkX3BheWxvYWRfb2Zmc2V0ID0gKih1
aW50MzJfdCopJmhkclsweDI0OF07DQoNCglmcHJpbnRmKHN0ZGVyciwgInNldHVwIHNlY3RvcnMg
JWRcbiIsIHNldHVwX3NlY3RvcnMpOw0KDQoJY29tcHJlc3NlZF9wYXlsb2FkX29mZnNldCArPSAo
c2V0dXBfc2VjdG9ycysxKSAqIDUxMjsNCg0KCS8vY29tcHJlc3NlZF9wYXlsb2FkX2xlbmd0aCA9
ICoodWludDMyX3QqKShwICsgY29tcHJlc3NlZF9wYXlsb2FkX29mZnNldCAtIDQpOw0KCWNvbXBy
ZXNzZWRfcGF5bG9hZF9sZW5ndGggPSAqKHVpbnQzMl90KikmaGRyWzB4MjRjXTsNCg0KCWZwcmlu
dGYoc3RkZXJyLCAiY29tcHJlc3NlZF9wYXlsb2FkX29mZnNldCAlIlBSSXgzMiIgKGFicylcbiIs
DQoJCWNvbXByZXNzZWRfcGF5bG9hZF9vZmZzZXQpOw0KCWZwcmludGYoc3RkZXJyLCAiY29tcHJl
c3NlZF9wYXlsb2FkX2xlbmd0aCAlIlBSSXgzMiJcbiIsDQoJCWNvbXByZXNzZWRfcGF5bG9hZF9s
ZW5ndGgpOw0KDQoJd3JpdGUoMSwNCgkgICAgICBwICsgY29tcHJlc3NlZF9wYXlsb2FkX29mZnNl
dCwNCgkgICAgICBjb21wcmVzc2VkX3BheWxvYWRfbGVuZ3RoKTsNCglyZXR1cm4gMDsNCn0NCg==


--=-birJsHmBodBQWcJqroMK--

--=-pnSvMQgPU58LpjdBxxCb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJOTgfrAAoJEOxjaZd5B0+omVYQAJOfyh1pXobvnOuDYHSVaJYE
DhCxDPTmkVUs8AWXljuRAujrzeh9H/v474VKpBdYKNT4IgMNLJXBBWEUuJ0pIKsn
1xvD+e2nGivK1WgBN7NCAvoTDK985QpWcUwness937aa49FkB36HkJT7QB+KdSS7
VYvb0K7NeXRT6KuNS9JTNYDoYmsMUISiXu6Ddvax70Dszv+c+9mcpuNr/O1LfF6Q
8iKfODsaYw0SM6xTWmlOJLexHS05tMimukxFriCXJS88u/oX/q32Vno6xyZvpqaA
npOy+gaUqA0cT78CkKrKzrxG1NoHW9d7Z7NH+Uf5IrUeC7TneL23SWH7aNcy9Oci
YFGT0vdNM0STcEefUkwSXRZ6B/bkjzSZTIl4stbpSdxPMo39DsHJyl1atAtxKOZD
7PAm/0tlCdgB4Z+g3n2degkqgMUlOzAfBpuQmaQprkwgjh68cMNbGW/GVDIoeMnT
QLuoO8xtFViy37L6+Ee+8sF1HaaSsLdLTvhtwXhXw7cIh2t4JICJ4JQ2Yggw7wi4
MDAjrAT2AL4yrn/NorWhkua7gMj5SzAzYByS3To0rLpySUFLaEEyVKDovet1UpbZ
UOeYa0IIl92smpuJccGwND/8nMOisz3k5+Pu2fnWCwUyTaretxrAPz4mzPpY//3z
bclz+msAL0wTJz3cSPfp
=qoW4
-----END PGP SIGNATURE-----

--=-pnSvMQgPU58LpjdBxxCb--

