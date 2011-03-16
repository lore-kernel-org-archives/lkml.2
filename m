Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1CPSK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:10:57 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:60282 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200Ab1CPSKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:10:52 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Mar 2011 14:10:52 EDT
Date: Wed, 16 Mar 2011 14:05:05 -0400
From: Frank Peters <frank.peters@comcast.net>
To: randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: 2.6.38 Compile Failure e1000e Module
Message-Id: <20110316140505.da5706ac.frank.peters@comcast.net>
In-Reply-To: <20110316082105.c911bb1c.randy.dunlap@oracle.com>
References: <20110316103318.19bd03e4.frank.peters@comcast.net>
	<20110316082105.c911bb1c.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011 08:21:05 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

>
> Please test this patch:
> 
> --- lnx-2638.orig/drivers/net/Kconfig
> +++ lnx-2638/drivers/net/Kconfig
> @@ -2099,6 +2099,7 @@ config E1000
>  config E1000E
>  	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
>  	depends on PCI && (!SPARC32 || BROKEN)
> +	select CRC32
>  	---help---
>  	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
>  	  ethernet family of adapters. For PCI or PCI-X e1000 adapters,


Yes.  The patch works.  The 2.6.38 source now builds.

Thanks to all responders.

Frank Peters
