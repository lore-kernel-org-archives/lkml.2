Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0HIKuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 06:50:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55076 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070Ab0HIKuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 06:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=K/wzrggiyZwSXtZlsLXuFQpIWW6DVH6P9qWNWPSh8KnqG+cQHNw2Zjfad0MzFTRS0Q
         qycnCTSpEoJEjPvDYv9BOIFO8IClbb5CI23Ob8dflDfzeZ/xBIu+2WP2/i9x38FUrRxQ
         9KlxcCQ7MD/XeIAZE9DbnbftMA7yGIIxZc+48=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=9BjWWdcZg0w772jcemjriQ5p0HV3EJB8OM68O@mail.gmail.com>
References: <1277811391-17966-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTi=jStVGbJC7jUyhOG3og14F58rw+LEN2UqnP-X0@mail.gmail.com>
	<AANLkTi=bkp+JJYQ7dF36Up3gcjJR8LypgfKBWZHLfPH-@mail.gmail.com>
	<AANLkTimPAeupEKwksBKOyWX8K+wHgmgc5vEJ8cXBsQtD@mail.gmail.com>
	<AANLkTi=yJjHDh08muCg7Z97xRGDcTQrv=VimHSNCqn2U@mail.gmail.com>
	<20100805071235.GA436@morgana.i.gnudd.com>
	<AANLkTinAuZ5GAauKHfUVV_K_9gQOpFY35m7SLsH6rvD1@mail.gmail.com>
	<AANLkTi=OLP+NwGP7v0O0=ZqBNp_Ag9mm+LEUnCw5OX7L@mail.gmail.com>
	<AANLkTi=9BjWWdcZg0w772jcemjriQ5p0HV3EJB8OM68O@mail.gmail.com>
Date: Mon, 9 Aug 2010 12:50:49 +0200
Message-ID: <AANLkTinmxFywsekEtwOm_YFM1u1D5R_LhO+GVAfi6+fy@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alessandro Rubini <rubini@unipv.it>, peter.pearse@arm.com,
        viresh.kumar@st.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, yuanyabin1978@sina.com,
        ben-linux@fluff.org, kgene.kim@samsung.com, rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/6 Dan Williams <dan.j.williams@intel.com>:

> ...except this version no longer compiles:

Hm the v3 version works fine with me, but anyway, I mailed out a v4
that also removes the unneeded mb() macros.

> Fix that up and we can try to get it in the second half of the merge window.

Great, thanks.

I'll work on getting this in place to run with the PrimeCell extensions
and proof-of-concept for ARM RealView reference designs next.

Yours,
Linus Walleij
