Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0JNB6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 21:58:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46864 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0JNB6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 21:58:31 -0400
MIME-Version: 1.0
In-Reply-To: <20101014125553.dc4ea7be.sfr@canb.auug.org.au>
References: <20101014125553.dc4ea7be.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 13 Oct 2010 19:58:07 -0600
X-Google-Sender-Auth: oFTGcZd2WJBseQ4Ax1pNSaXBnsQ
Message-ID: <AANLkTinCh3X7XJQpEVoP-fKqyXtVu1EZ+tVX_nNGQXyb@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the spi tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingkai Hu <Mingkai.hu@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 7:55 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> After merging the spi tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> drivers/mtd/devices/m25p80.c: In function 'm25p_probe':
> drivers/mtd/devices/m25p80.c:927: error: 'struct device' has no member named 'of_node'
> drivers/mtd/devices/m25p80.c:929: error: 'struct device' has no member named 'of_node'

Oops, I wasn't supposed to push that patch yet.  I'll pull it out.

g.

>
> Caused by commit 2bf990280d6074228f6e4c18ad01c0674c5c11c8 ("mtd/m25p80:
> add support to parse the partitions by OF node"). CONFIG_OF is not set
> for this build.
>
> I have used the spi tree form next-20101013 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
