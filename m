Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab0HaEq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 00:46:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40994
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754471Ab0HaEq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 00:46:26 -0400
Date: Mon, 30 Aug 2010 21:46:43 -0700 (PDT)
Message-Id: <20100830.214643.214234410.davem@davemloft.net>
To: joe@perches.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@suse.de, James.Bottomley@suse.de
Subject: Re: linux-next: build warning after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <1283227383.1759.33.camel@Joe-Laptop>
References: <1283224474.1759.30.camel@Joe-Laptop>
	<20100831135831.b0f124c4.sfr@canb.auug.org.au>
	<1283227383.1759.33.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 30 Aug 2010 21:03:03 -0700

> On Tue, 2010-08-31 at 13:58 +1000, Stephen Rothwell wrote:
>> On Mon, 30 Aug 2010 20:14:34 -0700 Joe Perches <joe@perches.com> wrote:
>> > On Tue, 2010-08-31 at 12:57 +1000, Stephen Rothwell wrote:
>> > > On Tue, 6 Jul 2010 14:25:42 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > > > After merging the net tree, today's linux-next build (powerpc
>> > > > ppc64_defconfig) produced these warnings:
>> > > > drivers/scsi/sym53c8xx_2/sym_hipd.c: In function 'sym_print_msg':
>> > []
>> > > > Introduced by commit 99bcf217183e02ebae46373896fba7f12d588001 ("device.h
>> > > > drivers/base/core.c Convert dev_<level> logging macros to functions").
>> > > Can we have a fix for these please?  They make too much noise in the builds.
>> > Submitted July 7
>> > https://patchwork.kernel.org/patch/111271/
>> Yes, but there were comments on that and nothing since.  I think that
>> James would like a minimal patch that just fixes the newly introduced
>> warnings.
> 
> Hi Stephen.
> 
> What I submitted I think reasonable.

Me too.

> He can extract what he wants if he prefers it done that way.

Exactly, he's the maintainter so if he wants something fixed a
specific way he can do it as he likes.
