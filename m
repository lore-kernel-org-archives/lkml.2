Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2IXL6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:58:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48498 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab2IXL6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:58:37 -0400
Date: Mon, 24 Sep 2012 21:58:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Wang Xingchao <xingchao.wang@intel.com>
Subject: Re: linux-next: build failure after merge of the drm tree
Message-Id: <20120924215834.0aca4ea8d04dee8e86abf446@canb.auug.org.au>
In-Reply-To: <20120924113137.GA3824@bremse>
References: <20120924131834.348fa5e6ecfa48521391ea62@canb.auug.org.au>
	<20120924113137.GA3824@bremse>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_21_58_34_+1000_ZA3fZQkCze7hySyS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_21_58_34_+1000_ZA3fZQkCze7hySyS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Mon, 24 Sep 2012 13:31:54 +0200 Daniel Vetter <daniel@ffwll.ch> wrote:
>
> Looks good. I've known about this issue and tried to improve matters by
> applying the patch to both trees (to at least force a conflict), but not
> even with that patch applied in my drm-intel-next queue I get a proper
> conflict. I guess I need to do a proper backmerge.
>=20
> Fixup patch looks good for now.

If that is all that is needed, just make sure Linus is informed of the
merge conflict fix when he merged the drm tree.  If there is more, it is
up to you and Dave.  If you do a back merge, make sure that it is
properly commented.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Sep_2012_21_58_34_+1000_ZA3fZQkCze7hySyS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYErqAAoJEECxmPOUX5FEcuAQAImgK29KPuXH62FvEoGj9OlQ
ylnLTqYMfYCxlZg+asYfdKRNvbbooVqC9pkgeZrZrzPosjh//ra8mPjZXczv8Gu7
wItuc6vYCqtkWovKl6mFIR34jsshezvpg/1g9pzKAPsJClPJAN4zpPRCE9MxKkQ9
mL1HpmsepUw2U361F1LsbD58pNuI5pA5oiBxt4fvw1ccepC2lnMJpEnxm4QUGmiL
tbAfQSpKq6nrvmb7skdygGvtziEwPKt5DhQs2QxJa5iGTk8Tn1VpAPU7c/yRmP4B
onNzugPace9hVQp/YeFnMXgnceD2RNpe/8lfAZsvxIUjzCZtfGbmCOFdYwqmaE3u
O0IEKvo20/C51tubzUua7vo9py4lUISpHdJ+RRtVtmgZQyqnLbtceWwsNW6ZGIGr
aZUNiic3UxClfIAuoXdXiUyN7BPvaMciMrgEyYFWnUg+z2gVk1GaCbwfvfV6lNBl
hWFbAr16KKt95cwOGK8A+P57GW5WW1tKfbTxuO6dHC9FZUtRLREw2Oa3uJsx1tWv
zNQFPxRWncw2XLSqWI4ybPgN2BzzUGGylXYwEKpYbhDvwF8WkOByJ837wTk9V/C1
fQGb/CRzOdhTtwUzcjkkL1n85E2yuvGy91HlKRNATAXdTpjoPhUETH6mRQaketk9
8XvZkTBUGaOWbL/suaBD
=hYUF
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_21_58_34_+1000_ZA3fZQkCze7hySyS--
