Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab0EXDml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 23:42:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63279 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab0EXDmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 23:42:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=BXCaNr4FRtp1DEFCSZas1Up/TMjg/Eah93NWUFZf/XVJNJNcJ3vLxnkGBZGI78e6F7
         1BvFlacXcGzDP0w/iYk2F5DXsOeVYvbEn2pCMfLvocOeJhMzh64fpJQtFklDSVg365Di
         6MzYhjDa5ZWDtrfoszkMFRHS2jqy9vrr5PpW4=
MIME-Version: 1.0
In-Reply-To: <20100524112405.3c62d22b.sfr@canb.auug.org.au>
References: <20100524112405.3c62d22b.sfr@canb.auug.org.au>
Date: Sun, 23 May 2010 20:42:38 -0700
X-Google-Sender-Auth: tfzw5LqFnwWhpKwUD-yRKrmIgiA
Message-ID: <AANLkTilefCp0WI-gFvuuXM6qrCO98I3GPJdN0UO6hfLI@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the async_tx tree
From: Dan Williams <dan.j.williams@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jassi Brar <jassi.brar@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 6:24 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Dan,
>
> After merging the async_tx tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> In file included from drivers/dma/pl330.c:19:
> include/linux/amba/pl330.h:15:32: error: asm/hardware/pl330.h: No such file or directory

Should have caught that in the review... changed the 'select PL330' to
a 'depends on PL300' and pushed it back out.

Thanks,
Dan
