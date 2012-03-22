Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab2CVQt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 12:49:59 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57468 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758677Ab2CVQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 12:49:54 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.4-dev
To: Jiri Slaby <jslaby@suse.cz>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>, apw@canonical.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in function declarations
In-Reply-To: Your message of "Thu, 22 Mar 2012 17:22:33 +0100."
             <4F6B51C9.6010904@suse.cz>
From: Valdis.Kletnieks@vt.edu
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com>
            <4F6B51C9.6010904@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1332434943_1970P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 22 Mar 2012 12:49:03 -0400
Message-ID: <4517.1332434943@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4F6B5802.0038,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1332434943_1970P
Content-Type: text/plain; charset=us-ascii

On Thu, 22 Mar 2012 17:22:33 +0100, Jiri Slaby said:
> That explanation is not fully correct. C99 explicitly says (6.7.5.3.14):
> An identifier list declares only the identifiers of the parameters of
> the function. An empty list in a function declarator that is part of a
> definition of that function specifies that the function has no
> parameters. The empty list in a function declarator that is not part of
> a definition of that function specifies that no information about the
> number or types of the parameters is supplied.
>
> So what you are trying to force here holds only for (forward)
> declarations. Not for functions with definitions (bodies). Is checkpatch
> capable to differ between those?

The fact that 'int foo() { /*whatever*/ }' with an empty parameter list
is *legal* doesn't mean that we can't collectively put our foot down and
say "This is too ugly to live in our source tree".

Is there any *legitimate* use of an empty parameter list in the kernel tree?

--==_Exmh_1332434943_1970P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT2tX/wdmEQWDXROgAQLIlQ/6AuUJSbgv16sd8I2Icf70tl2JUPd4eV7V
aw+5ltPbxFJZUFgKQMS4rtohSeEAEdr0l5T6yHeTr2A1B8P+ir+89/pao3WVdBTX
5ozCkJCZL9rlyOk+2fkvAAmLQDff0xBsj43TVTbH7rJdBkwfbyge3+aHs15k1Vb8
OnpTp65v1vO20F9b0VImM1dXZ6jeZUhpecQPUwQ/S/p2HbSJ6+bz8Ub1CEW67VWr
b8nKCO4pcUq7b4GU6tHf3qJNZYUYK1XmAB/wYjHeEVj2LVaB8WIZlAaBygsENT7a
6wMn3+MF5N+NLBxawWF5auUB8P5fswyDG1/5iqekd9t/DvxwqP5SMpphKq1RJ5mN
aoraGk+y95dm7lB9vijRfIES80jAMDrs6qfL81jrj3nyWekNsyQMyAxD/OKKFV5J
KRpqUeiJ+CvTFWeq1nNkRZN0WMDrtgr9sLh2ABnszwvPmDKFd/UCgFzCFSpEQ8uQ
z9OD6tTvzFmiMyXnC2aMzySRr2XEk9XoqLCbIVtUSUnA4at1JpN+8hx/DLMG1DyY
ktAQSeR3gZ+8Ozb+pw0Ms8FZfruBIlBsT883+JBc9ErQiaZChV/GWwCrnRuxlSDc
bnL2NQfl6fXwacx/H1fZhRGSmlSlckj6Xla8YMyaIAMfTis+9sR5J01bmjtEMXpm
nBVQv8w8cu8=
=+I9S
-----END PGP SIGNATURE-----

--==_Exmh_1332434943_1970P--

