Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab1IOF1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 01:27:34 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:38770 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab1IOF1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 01:27:33 -0400
Date: Thu, 15 Sep 2011 15:27:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the xen tree
Message-Id: <20110915152723.b3bdd6a5478c810245fabca1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Sep_2011_15_27_23_+1000_iNbQJWP5V6Zjpvq_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Sep_2011_15_27_23_+1000_iNbQJWP5V6Zjpvq_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the xen tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

arch/x86/xen/time.c: In function 'xen_set_wallclock':
arch/x86/xen/time.c:204:25: error: storage size of 'op' isn't known
arch/x86/xen/time.c:211:11: error: 'XENPF_settime' undeclared (first use in=
 this function)
arch/x86/xen/time.c:211:11: note: each undeclared identifier is reported on=
ly once for each function it appears in
arch/x86/xen/time.c:216:2: error: implicit declaration of function 'HYPERVI=
SOR_dom0_op'
arch/x86/xen/time.c:204:25: warning: unused variable 'op'

Caused by commit 7b11a83f592a ("xen/dom0: set wallclock time in Xen").

I have used teh xen tree from next-20110914 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Sep_2011_15_27_23_+1000_iNbQJWP5V6Zjpvq_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOcYy7AAoJEDMEi1NhKgbsF5QH/R0nZNn+WOYh0T78XaKtBknj
MElO5dSIxGgvblK0Cfq1OoTMNqVc246M5dMvTf+cA/FPaw7MYHXQHleENdcof3iE
sMSEORCI2upM2tu+ZWFfr475+AId9ZDQ0OMQ1pLqDsluBoy6dAqKFdkc8KYT+fWS
cJ9rrstjLOStuHledAtwYMJWzleIEQM6b/aeYv0lDu4cKyHdugm+JMuOPmzNGC0T
kjWx5FObAg+ijLnGRZsitLwlMspoAG5JQlqZKpM379IrV5A4yC3si6rJyNMTZtI9
Gvske2RIDJhjKVtHCybTuqHI5Qaox+ieB506ZKWyW/QeaLMFxbh39HuWRQb7cyk=
=/yH1
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Sep_2011_15_27_23_+1000_iNbQJWP5V6Zjpvq_--
