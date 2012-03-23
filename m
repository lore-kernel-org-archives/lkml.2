Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab2CWBVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 21:21:13 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57724 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab2CWBVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 21:21:11 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.4-dev
To: lwoodman@redhat.com
Cc: Christoph Lameter <cl@linux.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Motohiro Kosaki <mkosaki@redhat.com>
Subject: Re: [PATCH -mm] do_migrate_pages() calls migrate_to_node() even if task is already on a correct node
In-Reply-To: Your message of "Thu, 22 Mar 2012 16:14:04 -0400."
             <4F6B880C.7000805@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <4F6B6BFF.1020701@redhat.com> <4F6B7358.60800@gmail.com> <alpine.DEB.2.00.1203221348470.25011@router.home> <4F6B7854.1040203@redhat.com> <40300.1332445016@turing-police.cc.vt.edu>
            <4F6B880C.7000805@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1332465660_1929P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 22 Mar 2012 21:21:00 -0400
Message-ID: <3879.1332465660@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4F6BCFFF.0049,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1332465660_1929P
Content-Type: text/plain; charset=us-ascii

On Thu, 22 Mar 2012 16:14:04 -0400, Larry Woodman said:
> On 03/22/2012 03:36 PM, Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 22 Mar 2012 15:07:00 -0400, Larry Woodman said:
> >
> >> So to be clear on this, in that case the intention would be move 3 to 4,
> >> 4 to 5 and 5 to 6
> >> to keep the node ordering the same?
> > Would it make more sense to do 5->6, 4->5, 3->4?  If we move stuff
> > from 3 to 4 before clearing the old 4 stuff out, it might get crowded?
> >
> Yes, I didnt try to imply the order in which pages were moved just
> the additional moving necessary.

Oh, OK.. :)


--==_Exmh_1332465660_1929P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT2vP/AdmEQWDXROgAQIsnxAAumBOMgzOwiTT4rJs98vgUg8KKeo6ciYc
9thofQqjYmfJnHc/7nmhJSQASfUYLVHh16tL47ky+mazjYZgKCXY0Tfp7S1JXZX4
n/OV7AX1o2IezoufzrIFcBtEMh6UxwzR6DYifqBCgem6YBbePvBlCxKfve0Arxo3
QPoyxl+OYEh35SUXZFVDHzKuhX3NRxMsRaS2HMrGpeKxj7gLkovr6iDTGemDYvyU
sCGBpw8IRpUnkxcGXz/LFaf9MIenVEIeyZIW+ZYEqDzKbl3LYNiwWz66xzUhv4lw
/hoIz307L3Cw445C0vzBXQDCeXLDzoZ8A/c8bpvWItb4c2z9byeF/WZprW4I6j8z
aE1EUBicrdQQM9M2h8nhAe7bck+Zkl2onVtrLGZbVqcO6JQdGrxsnrcRr4B1Go1p
ASsfGMqjWK6Fj3dFQpz6wgyL9mMMoIGOwRFFDMD6QrTx5Xlr41JW/dOTNIiBBqvw
NBJ7u9UzAPoceefwfnzt95mwUlcGI7mWHzgpNN/9NK6fgJ2ukBE70/Q0TV68EcbH
2bBxEd+B6HlNcQQ+lt82EGLMocZ6gpnBF/W2dxJ7T2X87q0mhhQ2LuDb7QSe6+vs
tCA4VQL6AHA5E8tLOMlBkiyHfb8VR3rarN+/nIbBhyLQieiI6oqAJ552kVKhMRbn
CsxnZJWsTwA=
=8fMF
-----END PGP SIGNATURE-----

--==_Exmh_1332465660_1929P--

