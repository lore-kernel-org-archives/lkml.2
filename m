Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0G1NuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 09:50:25 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53255 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab0G1NuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 09:50:21 -0400
Message-ID: <4C503594.7040602@linux.vnet.ibm.com>
Date: Wed, 28 Jul 2010 08:50:12 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nathan Fontenot <nfont@austin.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        greg@kroah.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 6/8] v3 Update the node sysfs code
References: <4C451BF5.50304@austin.ibm.com> <4C451EAF.1080505@austin.ibm.com>
In-Reply-To: <4C451EAF.1080505@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2010 10:57 PM, Nathan Fontenot wrote:
> Index: linux-2.6/include/linux/node.h
> ===================================================================
> --- linux-2.6.orig/include/linux/node.h	2010-07-19 21:10:25.000000000 -0500
> +++ linux-2.6/include/linux/node.h	2010-07-19 21:13:11.000000000 -0500
> @@ -44,7 +44,8 @@ extern int register_cpu_under_node(unsig
>  extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
>  extern int register_mem_sect_under_node(struct memory_block *mem_blk,
>  						int nid);
> -extern int unregister_mem_sect_under_nodes(struct memory_block *mem_blk);
> +extern int unregister_mem_sect_under_nodes(struct memory_block *mem_blk,
> +					   unsigned long phys_index);

You also need to update the inline definition of unregister_mem_sect_under_nodes
for the !CONFIG_NUMA case.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


