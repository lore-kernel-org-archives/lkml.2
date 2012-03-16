Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032777Ab2CPO0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:26:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59407 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030751Ab2CPO0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:26:45 -0400
Date: Sat, 17 Mar 2012 01:26:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Hugh Dickins <hughd@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, akpm@linux-foundation.org,
        rob.lee@linaro.org, j-pihet@ti.com, khilman@ti.com,
        deepthi@linux.vnet.ibm.com, dan.carpenter@oracle.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle : fix random hangs with intel_idle
Message-Id: <20120317012628.4239343e48d748af2514b5b2@canb.auug.org.au>
In-Reply-To: <CAHLCerOeSHvFXb9ZnBDc1RjETbMLoMNYWqtrM=ipp_iX9XZ1cQ@mail.gmail.com>
References: <alpine.LSU.2.00.1203131454500.1335@eggly.anvils>
	<1331770181-800-1-git-send-email-daniel.lezcano@linaro.org>
	<20120315111415.cd119171ac86967aebe85545@canb.auug.org.au>
	<alpine.LSU.2.00.1203141720360.2003@eggly.anvils>
	<20120315135841.affff2d75681451d9ddd1a58@canb.auug.org.au>
	<CAHLCerOeSHvFXb9ZnBDc1RjETbMLoMNYWqtrM=ipp_iX9XZ1cQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__17_Mar_2012_01_26_28_+1100_mxFIdaebezXMbWbk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__17_Mar_2012_01_26_28_+1100_mxFIdaebezXMbWbk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Amit,

On Fri, 16 Mar 2012 15:37:07 +0200 Amit Kucheria <amit.kucheria@linaro.org>=
 wrote:
>
> A slight glitch: Rob is away until Tuesday. Should Daniel create a new
> branch to carry this?

I can keep applying it to linux-next, it just needs to be added to Rob's
tree before Linus is asked to merge it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__17_Mar_2012_01_26_28_+1100_mxFIdaebezXMbWbk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPY02UAAoJEECxmPOUX5FEmLsP+gN+CaJmHIVMbEa2PxTY4Xge
CxAxP7Zjoxo2wHQ2viixB0iSUSq2lAkrk7aQeI4jHehp/y5l2Pfcl/xJGgU856Br
W3EowcHieIjcKzQGEmvFSn6jDfE8k9ktI5uA2qaRfGQOtYtREnTCWxzgCRVVFueA
k+LRROoYDpwLS+39VM5Gss68vtFfbezapFisPbYrWHGsk3vL4SfphpEJhaB9VGo+
eojI6fyiF2tCnHtOCSFOvilTT2DI28ljr3eDWdayL6Lei/gbpvBJfUtGXJdQs7XK
PDH7CoXDMz4uOhFteG8onEZw9KvoIR3XeWfzTs0+jtPSTozZNg22uKyk9e6JuwDQ
JhAg5XSqcIl2wLFTFEFCYqrbm9gFagOx+Di3keCw0VmiOV49JVlsP744MLrwHodE
BusyfaKCfKEX+CxjEGTLPQdSvDH/AY1MjWOdtabhQ2Kl5ZaU7ZBs12q3zqgr5LWY
Om4xLiul8aaiYAUc4utxDy5WRZM2VY/OC09fZul/HYbfA/aSvf5ZFqqu71bfVhdu
EQe1/igne64QZX/wWeDV5iJt0x0wKVIuXsxhAufOOje06ftrVh7g+DlAFr7zjpX8
3HoTPkRJaLWe46HwrKuRGfg2mIzDumn8Xx1z8qRxadG+qn0QuiMPH4omPHoi29rX
7ax7I4jjG0J2AXMtQ+d4
=Sinv
-----END PGP SIGNATURE-----

--Signature=_Sat__17_Mar_2012_01_26_28_+1100_mxFIdaebezXMbWbk--
