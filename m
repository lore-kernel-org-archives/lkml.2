Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab0GHApM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 20:45:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40150
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756524Ab0GHApJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 20:45:09 -0400
Date: Wed, 07 Jul 2010 17:45:22 -0700 (PDT)
Message-Id: <20100707.174522.148565561.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, joe@perches.com, gregkh@suse.de
Subject: Re: linux-next: build warning after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100706142542.d723903f.sfr@canb.auug.org.au>
References: <20100706142542.d723903f.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 6 Jul 2010 14:25:42 +1000

> After merging the net tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
> 
> drivers/scsi/sym53c8xx_2/sym_hipd.c: In function 'sym_print_msg':
> drivers/scsi/sym53c8xx_2/sym_hipd.c:78: warning: zero-length gnu_printf format string

Thanks Stephen I'll look into this.
