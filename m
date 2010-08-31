Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab0HaDOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 23:14:37 -0400
Received: from mail.perches.com ([173.55.12.10]:1066 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678Ab0HaDOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 23:14:36 -0400
Subject: Re: linux-next: build warning after merge of the net tree
From: Joe Perches <joe@perches.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        James Bottomley <James.Bottomley@suse.de>
In-Reply-To: <20100831125738.7f18610b.sfr@canb.auug.org.au>
References: <20100706142542.d723903f.sfr@canb.auug.org.au>
	 <20100831125738.7f18610b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 20:14:34 -0700
Message-ID: <1283224474.1759.30.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 12:57 +1000, Stephen Rothwell wrote:
> On Tue, 6 Jul 2010 14:25:42 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > After merging the net tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced these warnings:
> > drivers/scsi/sym53c8xx_2/sym_hipd.c: In function 'sym_print_msg':
[]
> > Introduced by commit 99bcf217183e02ebae46373896fba7f12d588001 ("device.h
> > drivers/base/core.c Convert dev_<level> logging macros to functions").
> Can we have a fix for these please?  They make too much noise in the builds.

Submitted July 7

https://patchwork.kernel.org/patch/111271/



