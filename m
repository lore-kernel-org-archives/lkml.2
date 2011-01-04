Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163Ab1ADWee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 17:34:34 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36981 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1ADWec convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 17:34:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CeWafbzu4MiWcvY5HEBaRIXmtb3MNqYq+7rCgUajjGMdMFnFXVXbIjoumBwm9oTp+s
         95OJ/SsmjpK8CM8fIjzTmpUBAtAIvI8XWBy1c05avBbIaBygi4iSqXuCpBxKu3KcCRX/
         3k+RwF1y3bGAWwtNAZ2Wo1pQZFRd7GspdRfNA=
MIME-Version: 1.0
In-Reply-To: <AANLkTinMCLC8j=AvzaCQ+Uuyk75T=rAkaLUz0jHPOJ-d@mail.gmail.com>
References: <AANLkTinJAULeb1EsWk=S=b32h69X1x-noRw73Ok0uyfx@mail.gmail.com>
	<20110103165227.GC32508@n2100.arm.linux.org.uk>
	<AANLkTinMCLC8j=AvzaCQ+Uuyk75T=rAkaLUz0jHPOJ-d@mail.gmail.com>
Date: Tue, 4 Jan 2011 23:34:31 +0100
Message-ID: <AANLkTi=84fdEcS9EkgK-5CK0f43ZVJRHu0F6eKQpWTO6@mail.gmail.com>
Subject: Re: dmaengine: fix dma_unmap (was: Re: [PATCH 06/13] DMAENGINE:
 driver for the ARM PL080/PL081 PrimeCells)
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Peter Pearse <peter.pearse@arm.com>, linux-kernel@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>, yuanyabin1978@sina.com,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/3 Dan Williams <dan.j.williams@intel.com>:

> We could disable the driver if NET_DMA or ASYNC_TX_DMA are selected.
>  That still allows the driver to be exercised with dmatest.  Although
> I notice the driver is already marked experimental, do we need
> something stronger for 37-final?

Your pick, IMHO. To use it out-of-the-box with 2.6.37 is not possible
on any system anyway - we have not patched in the required
platform data to any ARM system! Those who do such things surely
know what they're doing.

Yours,
Linus Walleij
