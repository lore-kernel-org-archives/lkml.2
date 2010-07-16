Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0GPRS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 13:18:28 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59065 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab0GPRS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 13:18:27 -0400
Subject: Re: [PATCH 5/5] v2 Enable multiple sections per directory for ppc
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C3F5668.2060407@austin.ibm.com>
References: <4C3F53D1.3090001@austin.ibm.com>
	 <4C3F5668.2060407@austin.ibm.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Fri, 16 Jul 2010 10:18:08 -0700
Message-ID: <1279300688.9207.224.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 13:41 -0500, Nathan Fontenot wrote:
>  linux-2.6.orig/arch/powerpc/platforms/pseries/hotplug-memory.c      2010-07-15 09:54:06.000000000 -0500
> +++ linux-2.6/arch/powerpc/platforms/pseries/hotplug-memory.c   2010-07-15 09:56:19.000000000 -0500
> @@ -17,6 +17,54 @@
>  #include <asm/pSeries_reconfig.h>
>  #include <asm/sparsemem.h>
> 
> +static u32 get_memblock_size(void)
> +{
> +       struct device_node *np;
> +       unsigned int memblock_size = 0;
> + 

Please give this sucker some units.  get_memblock_size_bytes()?
get_memblock_size_in_g0ats()?


-- Dave

