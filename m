Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965788Ab0HFWzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:55:06 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58535 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965201Ab0HFWzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:55:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Telt7jBXmd5QChDNc7+SKgZgo5YN0s7htTjSe+kMCuQ7SYhexMsdzxDfjzCrXf5TQP
         UD0YJ0S0E2hPZtbVTJAxREEYzL6eaP5Nd7R8xjoPNfwQSUdIfo3GAq1cpOv4nbl9fE41
         5IXJMPR6YJIZULpmbfBT98H55BLvHWojrKz3U=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=OLP+NwGP7v0O0=ZqBNp_Ag9mm+LEUnCw5OX7L@mail.gmail.com>
References: <1277811391-17966-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTi=jStVGbJC7jUyhOG3og14F58rw+LEN2UqnP-X0@mail.gmail.com>
	<AANLkTi=bkp+JJYQ7dF36Up3gcjJR8LypgfKBWZHLfPH-@mail.gmail.com>
	<AANLkTimPAeupEKwksBKOyWX8K+wHgmgc5vEJ8cXBsQtD@mail.gmail.com>
	<AANLkTi=yJjHDh08muCg7Z97xRGDcTQrv=VimHSNCqn2U@mail.gmail.com>
	<20100805071235.GA436@morgana.i.gnudd.com>
	<AANLkTinAuZ5GAauKHfUVV_K_9gQOpFY35m7SLsH6rvD1@mail.gmail.com>
	<AANLkTi=OLP+NwGP7v0O0=ZqBNp_Ag9mm+LEUnCw5OX7L@mail.gmail.com>
Date: Sat, 7 Aug 2010 00:54:59 +0200
Message-ID: <AANLkTiki_69rgDCrMGtYwNmsp35EYiUedbLnYM_dvv+a@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alessandro Rubini <rubini@unipv.it>, peter.pearse@arm.com,
        viresh.kumar@st.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, yuanyabin1978@sina.com,
        ben-linux@fluff.org, kgene.kim@samsung.com, rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/6 Dan Williams <dan.j.williams@intel.com>:

> One
> thing that should be on the todo list is to review the usage of memory
> barriers.  I don't think they are serving the purpose that you think
> they are.

All of those are from Peters original implementation, I never use any
barriers so they actually looked alien to me. Unless I get a clear
rationale from Peter I'll just remove them all for the time being in
the fix-up version due after updating to generic slave control.

Yours,
Linus Walleij
