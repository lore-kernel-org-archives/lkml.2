Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759762Ab0HEGza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:55:30 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54163 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759640Ab0HEGz2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SgFC9kpAMQ0xkK76zP6ZQyxp9Q82YwW/Vw6cOftu+IG232MSYM/Anf51NSV7gd/OID
         N14g/tprmVv/H05jwoZiwyspWzHXv6kY0x6zBSGNrZy3h39pZvuR1hu+01DTktFboc5n
         83m0uo/l+yapeGhqVIwRy0mELwPUWD3yrYGvU=
MIME-Version: 1.0
In-Reply-To: <AANLkTimPAeupEKwksBKOyWX8K+wHgmgc5vEJ8cXBsQtD@mail.gmail.com>
References: <1277811391-17966-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTi=jStVGbJC7jUyhOG3og14F58rw+LEN2UqnP-X0@mail.gmail.com>
	<AANLkTi=bkp+JJYQ7dF36Up3gcjJR8LypgfKBWZHLfPH-@mail.gmail.com>
	<AANLkTimPAeupEKwksBKOyWX8K+wHgmgc5vEJ8cXBsQtD@mail.gmail.com>
Date: Thu, 5 Aug 2010 08:55:27 +0200
Message-ID: <AANLkTi=yJjHDh08muCg7Z97xRGDcTQrv=VimHSNCqn2U@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Peter Pearse <peter.pearse@arm.com>,
        Alessandro Rubini <rubini@unipv.it>,
        Viresh Kumar <viresh.kumar@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        yuanyabin1978@sina.com, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/4 Dan Williams <dan.j.williams@intel.com>:

> If there is a list of things to fix and no acked-by's from anyone on
> the cc list I assume you want to wait for 2.6.37??  I'm sending the
> dmaengine/async_tx pull request this Friday.

There are no blockers for merging this AFAICT, but some ACK:s would
be nice of course.

Peter, Alessandro and Viresh especially: you will hopefully use this
driver for ARM refboards, Nomadik and SPEAr, can you provide
an Acked-by:?

Yours,
Linus Walleij
