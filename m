Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab1I3BXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:23:42 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:37063 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab1I3BXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:23:40 -0400
Date: Fri, 30 Sep 2011 11:23:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Lu Guanqun <guanqun.lu@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, devel@driverdev.osuosl.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110930112337.02e0ba383ffd12b6d5d24f39@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Sep_2011_11_23_37_+1000_mT8Qs1FfyfKFusI1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Sep_2011_11_23_37_+1000_mT8Qs1FfyfKFusI1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (i386 allmodconfig)
failed like this:

drivers/staging/intel_sst/intelmid.c:52: error: expected declaration specif=
iers or '...' before string constant
drivers/staging/intel_sst/intelmid.c:52: warning: data definition has no ty=
pe or storage class
drivers/staging/intel_sst/intelmid.c:52: warning: type defaults to 'int' in=
 declaration of 'MODULE_AUTHOR'
drivers/staging/intel_sst/intelmid.c:52: warning: function declaration isn'=
t a prototype
drivers/staging/intel_sst/intelmid.c:53: error: expected declaration specif=
iers or '...' before string constant
drivers/staging/intel_sst/intelmid.c:53: warning: data definition has no ty=
pe or storage class
drivers/staging/intel_sst/intelmid.c:53: warning: type defaults to 'int' in=
 declaration of 'MODULE_AUTHOR'
drivers/staging/intel_sst/intelmid.c:53: warning: function declaration isn'=
t a prototype
drivers/staging/intel_sst/intelmid.c:54: error: expected declaration specif=
iers or '...' before string constant
drivers/staging/intel_sst/intelmid.c:54: warning: data definition has no ty=
pe or storage class
drivers/staging/intel_sst/intelmid.c:54: warning: type defaults to 'int' in=
 declaration of 'MODULE_AUTHOR'
drivers/staging/intel_sst/intelmid.c:54: warning: function declaration isn'=
t a prototype
drivers/staging/intel_sst/intelmid.c:55: error: expected declaration specif=
iers or '...' before string constant
drivers/staging/intel_sst/intelmid.c:55: warning: data definition has no ty=
pe or storage class
drivers/staging/intel_sst/intelmid.c:55: warning: type defaults to 'int' in=
 declaration of 'MODULE_AUTHOR'
drivers/staging/intel_sst/intelmid.c:55: warning: function declaration isn'=
t a prototype
drivers/staging/intel_sst/intelmid.c:56: error: expected declaration specif=
iers or '...' before string constant
drivers/staging/intel_sst/intelmid.c:56: warning: data definition has no ty=
pe or storage class
drivers/staging/intel_sst/intelmid.c:56: warning: type defaults to 'int' in=
 declaration of 'MODULE_DESCRIPTION'
drivers/staging/intel_sst/intelmid.c:56: warning: function declaration isn'=
t a prototype
drivers/staging/intel_sst/intelmid.c:57: error: expected declaration specif=
iers or '...' before string constant
drivers/staging/intel_sst/intelmid.c:57: warning: data definition has no ty=
pe or storage class
drivers/staging/intel_sst/intelmid.c:57: warning: type defaults to 'int' in=
 declaration of 'MODULE_LICENSE'
drivers/staging/intel_sst/intelmid.c:57: warning: function declaration isn'=
t a prototype
drivers/staging/intel_sst/intelmid.c:58: error: expected declaration specif=
iers or '...' before string constant
drivers/staging/intel_sst/intelmid.c:58: warning: data definition has no ty=
pe or storage class
drivers/staging/intel_sst/intelmid.c:58: warning: type defaults to 'int' in=
 declaration of 'MODULE_SUPPORTED_DEVICE'
drivers/staging/intel_sst/intelmid.c:58: warning: function declaration isn'=
t a prototype
drivers/staging/intel_sst/intelmid.c:64: error: expected ')' before 'int'
drivers/staging/intel_sst/intelmid.c:65: error: expected ')' before string =
constant
drivers/staging/intel_sst/intelmid.c:66: error: expected ')' before numeric=
 constant
drivers/staging/intel_sst/intelmid.c:67: error: expected ')' before string =
constant
drivers/staging/intel_sst/intelmid.c:461: warning: data definition has no t=
ype or storage class
drivers/staging/intel_sst/intelmid.c:461: warning: type defaults to 'int' i=
n declaration of 'EXPORT_SYMBOL_GPL'
drivers/staging/intel_sst/intelmid.c:461: warning: parameter names (without=
 types) in function declaration
drivers/staging/intel_sst/intelmid.c:475: warning: data definition has no t=
ype or storage class
drivers/staging/intel_sst/intelmid.c:475: warning: type defaults to 'int' i=
n declaration of 'EXPORT_SYMBOL_GPL'
drivers/staging/intel_sst/intelmid.c:475: warning: parameter names (without=
 types) in function declaration
drivers/staging/intel_sst/intelmid.c: In function 'snd_intelmad_probe':
drivers/staging/intel_sst/intelmid.c:859: error: 'THIS_MODULE' undeclared (=
first use in this function)
drivers/staging/intel_sst/intelmid.c:859: error: (Each undeclared identifie=
r is reported only once
drivers/staging/intel_sst/intelmid.c:859: error: for each function it appea=
rs in.)
drivers/staging/intel_sst/intelmid.c: At top level:
drivers/staging/intel_sst/intelmid.c:989: error: 'THIS_MODULE' undeclared h=
ere (not in a function)

Presumably revealed by the module.h split up.  This file needs to include
mofdule.h.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Sep_2011_11_23_37_+1000_mT8Qs1FfyfKFusI1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOhRoZAAoJEDMEi1NhKgbsCloH/1LPmSSfds3ZEWiHIkqGEZ6q
LMaPGNwVq8Cv641L/33cYQC/5s0Lr47n0ddgmVjDPxnsitiMgUUe9XGWiaU9CUQ/
jnk8qXOBB/YoP7sb93ukDC0ZJvfWFYpcjWlq5vMaBj3avYk8iyovVHxDKSJ3WKOd
gQWOV++LjU6KfBxCWpewrW9UN0qI23N0iT89AXoB25arP27OSpKs1alsPopu8MK/
txEHCuA9+l2KAlcHdIKvgBkxf0wJcvBKqQEhAaf+SQ1hd5Q4I04yrLw2H9h37Ez7
A1brycyroh9XWwvv7YEx8VPboVMzIRMyi8iJr8LxzgGa2AS3fUEUysFKKuuGqBM=
=kE+I
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Sep_2011_11_23_37_+1000_mT8Qs1FfyfKFusI1--
