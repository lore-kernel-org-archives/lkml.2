Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab0JHAKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:10:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40254 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab0JHAK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:10:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=nb5d02kb6/cHWqdE9esShuqQFo/dg93mfKYL00x8QD9GxTlOMpBPHGaEEA9rqk53ws
         mMS495yOE8RKr+i//aXeO91V76OXkZeWLk1GwfzZmslXIY07GFp5MywCN4S3oMAiyj32
         sXYvVvwbQQwtXaPR/I3/+H+tdHN7kohCXgOQM=
MIME-Version: 1.0
In-Reply-To: <1286355929-31226-1-git-send-email-linus.walleij@stericsson.com>
References: <1286355929-31226-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 7 Oct 2010 17:10:25 -0700
X-Google-Sender-Auth: LpVf5mmh4UG52Y8waFK1_pDiYIw
Message-ID: <AANLkTikSbJwsbSNBjGkcgW2=3FfmhF3W-NQD=3-vdcPD@mail.gmail.com>
Subject: Re: [PATCH 0/3] DMAENGINE: DMA40 burst size conquest
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 2:05 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> Hi Dan,
>
> this patch set gives the device runtime control functions complete
> control over burst size, and remove the local hooks to handle this
> in the platform code.
>
> Since [2/3] touches platform code that was touch by stuff queued
> up in Russells ARM tree, I took it out of his patch tracker and
> included it in this patch set instead so as to avoid conflicts, hope
> it's OK.
>
> This can go on top of the bug fixes send earlier, but will probably
> also apply on their own.

This and the last set applied.

Thanks,
Dan
