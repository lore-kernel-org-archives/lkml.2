Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab0DMPWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:22:50 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52378 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab0DMPWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:22:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=O7urAdhMGERZandldJcjwynCLKVMilJX3tH/UCFX6aYKAOZubHjWCVIb0Q6wLtDpf7
         PwNKBMeE//l0mI7GirqCjpSRso2Ng3ZBz9x+nTwajFn+h0Z0s3kbWAktrbnFbsmYznkU
         v1Bv286kCeb4P/T6xVN8TJKdRJZEEmXETmj4c=
MIME-Version: 1.0
In-Reply-To: <1269956022-31299-1-git-send-email-linus.walleij@stericsson.com>
References: <1269956022-31299-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 13 Apr 2010 17:22:47 +0200
Message-ID: <z2g63386a3d1004130822jd41faedcp4929aa2d389687d5@mail.gmail.com>
Subject: Re: [PATCH 1/2] DMAENGINE: Support for ST-Ericssons DMA40 block v3
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       STEricsson_nomadik_linux@list.st.com,
       Alessandro Rubini <rubini@unipv.it>,
       Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/30 Linus Walleij <linus.walleij@stericsson.com>:

> This is a straightforward driver for the ST-Ericsson DMA40 DMA
> controller found in U8500, implemented akin to the existing
> COH 901 318 driver.

Dan, if this driver is fine can it be put into the async_tx tree?
Andrew already has it in his tree but it shouldn't cause any problems
in my limited experience.

Linus Walleij
