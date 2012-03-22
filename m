Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab2CVThJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 15:37:09 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:53199 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab2CVThG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 15:37:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.4-dev
To: lwoodman@redhat.com
Cc: Christoph Lameter <cl@linux.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Motohiro Kosaki <mkosaki@redhat.com>
Subject: Re: [PATCH -mm] do_migrate_pages() calls migrate_to_node() even if task is already on a correct node
In-Reply-To: Your message of "Thu, 22 Mar 2012 15:07:00 -0400."
             <4F6B7854.1040203@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <4F6B6BFF.1020701@redhat.com> <4F6B7358.60800@gmail.com> <alpine.DEB.2.00.1203221348470.25011@router.home>
            <4F6B7854.1040203@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1332445016_39840P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 22 Mar 2012 15:36:56 -0400
Message-ID: <40300.1332445016@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4F6B7F59.012F,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1332445016_39840P
Content-Type: text/plain; charset=us-ascii

On Thu, 22 Mar 2012 15:07:00 -0400, Larry Woodman said:

> So to be clear on this, in that case the intention would be move 3 to 4,
> 4 to 5 and 5 to 6
> to keep the node ordering the same?

Would it make more sense to do 5->6, 4->5, 3->4?  If we move stuff
from 3 to 4 before clearing the old 4 stuff out, it might get crowded?


--==_Exmh_1332445016_39840P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT2t/VwdmEQWDXROgAQIkgg//WSjenDA84KouiK00Bf7PdzfwvRLox3kL
3IN/CMMaPLbOIjjO1Uy8NpCJAgNRTrR40mpzAY3zLs3y7Ir6bYb9W2UtG72Xu/Io
XdsTkXQQ4BQvBsOe21YSqKVORtziXLw9LhlDpfJRPog+ocDjIrlK5twCG4VpSisf
Vl1RwbEkRMFlEJSHCbzwbzlaMNgG9CAdBxD+hnFsAgTgk+bXW37zEhw+v07tWtVU
Foy1Cpa/QhHyxuuQ9MvMALu8jO8g4fzhUB10JRbLUa7e3AKZ9G/Sp0pBGIDpgMkd
40HNg0Xf3Yv0PBRBtAjQSojiu+iFwohsA3ian1aPHZVR7Zp8pFi3RC1QVZcpI+lq
3WAi5zvM9oeVnKxUTy1ya1w9cG8vf8XFgI1WOomtVfDIc0Ndd6yCvWU7DfLknkTb
pDN1DdH0MtGZtym64C4DbRdp4Vy9cjcYOD9OcFN1+ZGx/pD3ggzUw9bPZcH5/AFh
Hqlhrr+7bf+fTsdoIqspVXhs+NlrRQegQTyJjivOitTKcehrG6WcQYta8q51uLF7
Jl6ms8dlPJWrLiXZSCSdfEMxf0AQj/yoyzSB7rtixPQyOPLrKGs6nkZhpjmjdO/D
v3edqqnCHcoVyEtJS83UN3A6qU5a0qg5pM3npB2gHjP4uQp6HChWBIz+rMV/gCy0
lDzYDAe23OE=
=xLes
-----END PGP SIGNATURE-----

--==_Exmh_1332445016_39840P--

