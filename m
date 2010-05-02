Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0EBBEA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 21:04:00 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:47948 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab0EBBD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 21:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NQzdcr9QF2bGOboP1T62fwM15WoLUWE998fzFMokbq9zgkc4dc/M4zOyyAVSYkngCL
         RHrG4xgWstOV5vLQ3l9vJypU3xoF30KvDVku0tfGaI5Uc3lvcgGSALANkFX2LrMJOdhL
         KwvENLIXiXF80FBngnKZSaW1n/Rs2m+84h0Oo=
MIME-Version: 1.0
In-Reply-To: <h2te9c3a7c21005011748r234216a2o35c5a979e9e7f0ca@mail.gmail.com>
References: <1271481165-9848-1-git-send-email-linus.walleij@stericsson.com>
	 <h2te9c3a7c21005011748r234216a2o35c5a979e9e7f0ca@mail.gmail.com>
Date: Sun, 2 May 2010 03:03:57 +0200
Message-ID: <g2m63386a3d1005011803gb012d3adv9c347094f1bad8ed@mail.gmail.com>
Subject: Re: [PATCH 3/3] DMAENGINE: add PrimeCell generic DMA to PL022 v6
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/2 Dan Williams <dan.j.williams@intel.com>:

> I just back-merged 2.6.34-rc4 into async-tx to pick up the
> gfp.h/slab.h conversion... prior to reading this patch.  Can I just
> use v5?

You can, but I'll have to make some more amendments to it
for the stuff that Russell wants so as to keep all PrimeCells
uniform, so you could just as well hold it back a little while more.

Yours,
Linus Walleij
