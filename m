Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab2HTGL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 02:11:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50224 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2HTGLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 02:11:55 -0400
Date: Mon, 20 Aug 2012 16:11:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        AceLan Kao <acelan.kao@canonical.com>
Subject: linux-next: build failure after merge of the drivers-x86 tree
Message-Id: <20120820161146.8961b8d9151f11a27b2fb48f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__20_Aug_2012_16_11_46_+1000_KILVy.JL0v5_KzTC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Aug_2012_16_11_46_+1000_KILVy.JL0v5_KzTC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

After merging the drivers-x86 tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/platform/x86/asus-wmi.c: In function 'asus_new_rfkill':
drivers/platform/x86/asus-wmi.c:892:3: error: implicit declaration of funct=
ion 'rfkill_set_led_trigger_name' [-Werror=3Dimplicit-function-declaration]

Caused by commit 154a7a7b2234 ("asus-wmi: update wlan LED through rfkill
led trigger").  Please build test this stuff ... according to the bug
report, this patch depends on another rfkill patch.

I have used the drivers-x86 tree from next-20120817 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__20_Aug_2012_16_11_46_+1000_KILVy.JL0v5_KzTC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQMdUiAAoJEECxmPOUX5FEfD4P/irbo588D9YNcsh2D6+VeAw3
pctH0iGIRzbf7kJvGkfuJ2gr00kGDWB+CgVpWieu9ln8l99kj0E3NuNWc7FGQswI
eyVZIpzrjdd3NW4G0E6wrCJ1lfg2nnlT1+BE4gn+skSEKmmKa5u6PoYExJOzUtsx
9u/XnBFWOWklLD9RU3x2XtAvh5LjhjDD4ki/UJoDBkYodMkHzXF6hpovjJExPsJP
U5tYZDg69MAV1bVGakwDco/reU2ufSd5uLshVWZqU+RicqgmR7Vpr3Iur0CQi1ka
rpwVZ+yCSRj++k3P+rQ/UxiCVEskIyjBMz9JApLQ9axS5Vt9A68IjB+stjbyEpaT
xNELZ92XUsCxxbzXZP/LwYNRzk3kSDUXAcFTk6hc5SdYYkQ4KMGPggdeSzLfT9jU
naTn4gEyjIhwffUS0+KXLsGYNJKyigiUYo4gzjccV1nQO8Pj20MXYZ8k/LFSQVZo
bXzK3mx0xiK5N+kBCZi6ZT+avjt63Lv5b9DTk/wpm7drPHeFz61CU9ip29ItCeb/
/Tq1eGEe6IK6idlSil5qWbqzOX3JmC0IZlaTfoUbHKbxDCpBShxe6b348M80B7kK
D8pJxWIeoM/F9yfdS+aTPpVEK2MS5yC4xa5W8fnOtYh40r15TxRfnAoSrk0qdL2Z
2Z30juZbWgGmPj8IKzMn
=lR65
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Aug_2012_16_11_46_+1000_KILVy.JL0v5_KzTC--
