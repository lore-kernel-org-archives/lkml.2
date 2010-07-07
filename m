Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab0GGFng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 01:43:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47037 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0GGFnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 01:43:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k+l4jQiC2WxrtP4UmS/4zlmnEfl4/FXJVc90iq3K6AnWtitPQuR0npt37YxTR6+V0p
         DGDfrNo7Q1/fVU0OP+XBVDXVOOFW9dU7i20/cBCkAoQ3Yc7LgxAilJbV1I7KcezIk+0S
         D/rRIsQM0gT1wcZnRs/s7NqMVrtUfC0B8VNBU=
Subject: Re: [PATCH] Staging: et131x: fix coding style issues in
 et131x_initpci.c
From: Joe Eloff <kagen101@gmail.com>
Reply-To: kagen101@gmail.com
To: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100706222954.432ffcdd@linux.intel.com>
References: <1278436628.5396.75.camel@dermezel>
	 <20100706222954.432ffcdd@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Jul 2010 07:43:14 +0200
Message-ID: <1278481394.5396.88.camel@dermezel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-06 at 22:29 +0100, Alan Cox wrote:
> On Tue, 06 Jul 2010 19:17:08 +0200
> Joe Eloff <kagen101@gmail.com> wrote:
> 
> > >From e23e19537c4d62bc76ae982859d3c3225a45d9c2 Mon Sep 17 00:00:00
> > >2001
> > From: Joe Eloff <kagen101@gmail.com>
> > Date: Tue, 6 Jul 2010 19:13:28 +0200
> > Subject: [PATCH] Staging: et131x: fix coding style issues in
> > et131x_initpci.c
> > 
> > This is a patch to the et131x_initpci.c file that fixes up all the
> > line lengths over 80 by the checkpatch.pl tool.
> 
> That is one area where checkpatch can be misleading. If you split
> messages like that it becomes hard to grep for them.
> 
> Where it is useful is where you have
> 
> 	printk("blah blah bah blah [120 chars]", functioncall(foo))
> 
> and it would hide things like functioncall(foo)
> 
> No argument about the comment ones however.
Noted and understand why you would want to grep and output when
debugging.
Will make better judgement calls thanks to these messages.

Regards,

Joe

