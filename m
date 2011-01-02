Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab1ABU3N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 15:29:13 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58523 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1ABU3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 15:29:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QiFyopiPN7FXTK8XtdLJflSElmYIP+sty34jKggl5mEsPH0RwGETVfpE2NAK1SCzn4
         fhB0YB6zzRA9/+krtIQ9UNdmMgnGobfmG2s+vGx3UuG7PeHe1mXVWR9aSCY1+Zux37Y9
         uPAadx5fAlGEfDjjk4J/TnMOBHaW12hTEKE4Q=
MIME-Version: 1.0
In-Reply-To: <20110101151545.GC25924@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<20101221182037.GA4783@n2100.arm.linux.org.uk>
	<20101222122904.GC14693@n2100.arm.linux.org.uk>
	<AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
	<20110101151545.GC25924@n2100.arm.linux.org.uk>
Date: Sun, 2 Jan 2011 21:29:10 +0100
Message-ID: <AANLkTi==a7vSCnSewcjrTWeqhV47=fEwxG3qWaz6RWYh@mail.gmail.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/1 Russell King - ARM Linux <linux@arm.linux.org.uk>:

> As a side note, the DMA mapping for slaves should be done using the
> DMA struct device, not the struct device of the peripheral making use
> of the DMA engine.

FYI I patched the amba-pl022.c for this (and your other immediate
comments) and it's queued for the next merge window.

Yours,
Linus Walleij
