Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0J0H3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 03:29:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42316 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab0J0H3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 03:29:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UEPCm7P2D5ORJjY5tH7qaM6UCU8vHsmB080tO+RMcIZi1qVml6u5uRIuifnSgLxlgk
         rxjid+vc0y0WWezU1q4NFynXocLECzd2mg2B5sXJsojXJ6SvMaF73bJpEqZclsH5gTCA
         bcFfisbjFHhrtc0SX5CJwXJDcezr1+Z34OOxM=
MIME-Version: 1.0
In-Reply-To: <20101027113341.e77169cc.sfr@canb.auug.org.au>
References: <20101027113341.e77169cc.sfr@canb.auug.org.au>
Date: Wed, 27 Oct 2010 10:29:22 +0300
X-Google-Sender-Auth: nP4_j_WIeq8QsZ4zNyPc1MiZw6I
Message-ID: <AANLkTinVmdWkG5zDgbPN0V=2Z2rQM=oksdxevcS_xdmz@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the slab tree
From: Pekka Enberg <penberg@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 3:33 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the slab tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> gcc: /scratch/sfr/next/Documentation/vm/slabinfo.c: No such file or directory
> gcc: no input files
>
> Caused by commit f5ac4916e9840292edd33c7a52b10364526547f3 ("slub: move
> slabinfo.c to tools/slub/slabinfo.c").  Missing update to
> Documentation/vm/Makefile?

Oh, we have one of those. Sorry about the breakage, I'll fix it up later today.
