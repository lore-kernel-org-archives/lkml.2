Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab0IFXvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 19:51:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33439 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab0IFXvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 19:51:00 -0400
Date: Mon, 6 Sep 2010 16:49:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 6 (drivers/base/core)
Message-Id: <20100906164918.56487d92.randy.dunlap@oracle.com>
In-Reply-To: <20100906141727.646c68e7.sfr@canb.auug.org.au>
References: <20100906141727.646c68e7.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Sep 2010 14:17:27 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100903:
> 
> The powerpc tree still has its build failure for which I applied a patch.
> 
> I still have a patch to the drivers-x86 tree to remove a Kconfig warning.
> 
> ----------------------------------------------------------------------------


when CONFIG_BLOCK is not enabled:

drivers/base/core.c:622: error: 'block_class' undeclared (first use in this function)
drivers/base/core.c:712: error: 'block_class' undeclared (first use in this function)
drivers/base/core.c:742: error: 'block_class' undeclared (first use in this function)



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
