Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab2KTBi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:38:28 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:35287 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2KTBi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:38:27 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 8/9] x86: ramdisk info print with high bits.
In-Reply-To: Your message of "Fri, 16 Nov 2012 11:32:50 -0800."
             <CAE9FiQUkWug18Bdyjp7ocJxCCJxpa7+tY0+eQ301pY1a-f+JUw@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org> <1353055989-31939-9-git-send-email-yinghai@kernel.org> <50A6644D.80205@zytor.com> <CAE9FiQXJqyUf7qAspG_ZKUPV96QQjayp8cM0ihQ0RpyU5AxBMA@mail.gmail.com>
            <CAE9FiQUkWug18Bdyjp7ocJxCCJxpa7+tY0+eQ301pY1a-f+JUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1353375484_1855P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Nov 2012 20:38:04 -0500
Message-ID: <45353.1353375484@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.50AADEFE.00DB,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1353375484_1855P
Content-Type: text/plain; charset=us-ascii

On Fri, 16 Nov 2012 11:32:50 -0800, Yinghai Lu said:
> On Fri, Nov 16, 2012 at 11:21 AM, Yinghai Lu <yinghai@kernel.org> wrote:

> > or you prefer to cast them to pointer and use %pR for them all?
> >
> > or fix printk to add extra 2 for "0x" when # is found?
>
> looks like we have lots of %#010llx or %#010Lx there in arch/x86.
>
> We need to fix printk to make it acting like %pR ?

I'd prefer fixing the code to use %pR - when I'm looking at the code,
that tells me more about the intended semantics than $# does.

But I'm basically just a crash test dummy here - the x86 maintainers
of course get to make the decision what they'd prefer to have.


--==_Exmh_1353375484_1855P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUKre/AdmEQWDXROgAQK6lg//Rdo2CL0+Ukpme8WDNYkja82Au3yqbMxe
9Ca9ucuw1mifuDwHB7pbNvEfyocfb1lxDsa9eB7N1pu4+uscMDyuxFPPOQx4lLwr
KHNyiW4HuP8lAHyjvm5G/Ap38N+kxSIta0PPWL4RRnuf4Lb4j1t35tX6kl9coj5g
1KXbq51fMI9WkwQ/kORcGLFavNgFM+RtKHw2V32jshOdj+w1IdJbaG4uTF046/l8
0wmJdxFW0guFK0ITX2/JZWEkmZWjWcWl908WP1es5RiUmu+sy5sx4o9qzVtEZjUK
Bdhc7d8BY11N1u6WyUW2/7AHvjJMCMDvNHH8f87H7zdY+49Cv4YNPP0IkLVMw6SH
0VVwpyIF1bj0mgHXqxKv+5kl3tQUh1F1ZAn33N+Oqc/F50TZFEL+4VuXpyuw1AiW
NM7dxBreYl1RTdUaAFspRawgEohPUpSlHjds0iLGYq7kOigqrPr12I1mjaNYGgyS
9LzsnVN6dNG083pHjG0kM1Qqb+Cc7iIcE/BpKopscgoq5dfgF9W2SWqS0Y8zIp4e
iOXCrP358tlQpDLFbeeIdxVxhhApd6XXuyvBGoOe7tmOF7NkQnbngKh41Rtd1TF4
vOyLa2VKPOiAYA4eNkHiWH0dvedp4Lgz7RRRIwDsckiT96txymeOjELQbgcx1JWu
JDnERIDOGaw=
=8tGs
-----END PGP SIGNATURE-----

--==_Exmh_1353375484_1855P--

