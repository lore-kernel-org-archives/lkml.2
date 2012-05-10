Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2EJWoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:44:22 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:40358 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761692Ab2EJWoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:44:20 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] PA-RISC: fix compile
Date: Fri, 11 May 2012 00:44 +0200
Message-ID: <24772505.xKFVoyPWuj@donald.sf-tec.de>
User-Agent: KMail/4.8.3 (Linux/3.2.9-13-desktop; KDE/4.8.3; i686; ; )
In-Reply-To: <CA+55aFwWrkmqFPW=hOPCiNDE9CGXrwk85W7-vt2Aeg5EC1MtJQ@mail.gmail.com>
References: <4430485.xEvkeJU8MB@donald.sf-tec.de> <CA+55aFwWrkmqFPW=hOPCiNDE9CGXrwk85W7-vt2Aeg5EC1MtJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2476140.ODqGFRtFtZ"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2476140.ODqGFRtFtZ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Linus Torvalds wrote:
> On Thu, May 10, 2012 at 1:50 PM, Rolf Eike Beer <eike-kernel@sf-tec.de> 
wrote:
> >  arch/parisc/include/asm/hardware.h |    3 ++-
> >  arch/parisc/include/asm/page.h     |    6 ++++++
> >  arch/parisc/include/asm/pdc.h      |    7 -------
> >  arch/parisc/include/asm/pgtable.h  |    2 ++
> >  arch/parisc/include/asm/spinlock.h |    2 ++
> >  arch/parisc/kernel/pdc_cons.c      |    1 +
> >  arch/parisc/kernel/time.c          |    1 +
> >  drivers/parisc/sba_iommu.c         |    1 +
> >  drivers/video/console/sticore.c    |    2 ++
> >  include/asm-generic/getorder.h     |    2 +-
> >  10 files changed, 18 insertions(+), 9 deletions(-)
> 
> The diffstat doesn't match the actual patches - there are no getorder.h
> changes.
> 
> Hmm?

Yes, sorry. That diffstat is of the old patch series that included the 
getorder.h patch I now sent to you seperately as it doesn't have to do with 
the compile breakage itself.

Eike
--nextPart2476140.ODqGFRtFtZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk+sRLoACgkQXKSJPmm5/E4UtwCfSmH1eJ9pCsa/pPaQnGx3Tder
amwAoJ8y0oEj7uKnnJGgqPtVRJZsSB+v
=pV3S
-----END PGP SIGNATURE-----

--nextPart2476140.ODqGFRtFtZ--

