Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab1HRJ2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 05:28:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40454 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab1HRJ2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 05:28:01 -0400
Date: Thu, 18 Aug 2011 19:27:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the moduleh tree
Message-Id: <20110818192754.972382bbed8fa3adc6dca9c5@canb.auug.org.au>
In-Reply-To: <201108181026.51813.rjw@sisk.pl>
References: <20110818150945.b429ef302fd45a6a309b52d4@canb.auug.org.au>
	<201108181026.51813.rjw@sisk.pl>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__18_Aug_2011_19_27_54_+1000_y4Qf+3v8RBOlBzsl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Aug_2011_19_27_54_+1000_y4Qf+3v8RBOlBzsl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

On Thu, 18 Aug 2011 10:26:51 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
> Do you mean that drivers/base/power/common.c should include module.h
> or something else?

Yes, that is exactly what I mean :-)  See Rule 1 in
Documentation/SubmitChecklist.  The reason it is different, is because
the module.h splitup is cerating export.h for files that just need
EXPORT_SYMBOL (like this file).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__18_Aug_2011_19_27_54_+1000_y4Qf+3v8RBOlBzsl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTNsaAAoJEDMEi1NhKgbs5R8H/2ToNTvmZMNryHiw4IZ3qisI
xd5Q9O27pOugSOTmVVMeCKp3b1b0C9uSPjMTuQdY+CcmBIyTI5F03bTIcfowO4qf
+SxTb1jz81gHG+2tMq/yuBsf6rGpUNxx6GPh7VExi0N1StOJTIZprMSamfdyIGSB
vJELomuEYgwqqJp0LiPBUjUp/7oXyAaeHQPKx/g/T8PZVF3K4O/LoY0ziweORk4j
AJm/vmxXbGU7/ZM7ZE5vD88Qvkd7h5SQlW2xvWfxDWF4rLMLvaf3asIYYpvjOcNH
yJgw/derFIflMnYEmC5Z2ANMe1txnDfU6QOW9cLCTwYydFiopvOOXSNggMwa+eU=
=I960
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Aug_2011_19_27_54_+1000_y4Qf+3v8RBOlBzsl--
