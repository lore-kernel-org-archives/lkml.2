Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab0D0TRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:17:53 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55775 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab0D0TRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:17:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gGEwCY07Ezdcz+2ZoSpfbN5Lv+Yyzluhtwn1jWyottRz+W+DWbFQNBh9jPzuOvMeon
         OKa3nxGdbR2Lpb1csn5/ixH4YZvDsqU92M/6dIas/U/+DBRrPMUio03xo5qYaUZkcg9v
         l3kfhxNbw90qWak2yNlVbP+1wdKKo80CAzxrQ=
MIME-Version: 1.0
In-Reply-To: <1269956049-31564-1-git-send-email-linus.walleij@stericsson.com>
References: <1269956049-31564-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 27 Apr 2010 21:17:50 +0200
Message-ID: <k2i63386a3d1004271217h5e194d81u58c6bd8ce00bc5ed@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: DMA40 U8500 platform configuration v3
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       STEricsson_nomadik_linux@list.st.com,
       Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

feel free to drop the patch titled:
dmaengine-dma40-u8500-platform-configuration-v3.patch

>From your patch stack, it's been superseded and will hopefully
be merged through Russells tree pending some changes to our
board structure in u8500/ux500.

Yours,
Linus Walleij
