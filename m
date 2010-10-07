Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575Ab0JGNLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 09:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760564Ab0JGNLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 09:11:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20101007150835.9e1a49f7.sfr@canb.auug.org.au>
References: <20101007150835.9e1a49f7.sfr@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: linux-next: manual merge of the irqflags tree with Linus' tree
Date: Thu, 07 Oct 2010 14:11:37 +0100
Message-ID: <26564.1286457097@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Today's linux-next merge of the irqflags tree got a conflict in
> arch/mips/kernel/irq-gic.c between commit
> 863cb9bad8f992a9c171e90552045eac77808e84 ("MIPS: GIC: Remove dependencies
> from Malta files") from Linus' tree and commit
> 9cbb8e371af264699522030ec637c55a58765859 ("MIPS: Add missing #inclusions
> of <linux/irq.h>") from the irqflags tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Fixed in the irqflags tree.

David
