Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761498Ab0GTTXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 15:23:25 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:38650 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658Ab0GTTXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 15:23:21 -0400
Subject: Re: [PATCH 8/8] v3 Update memory-hotplug documentation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, greg@kroah.com
In-Reply-To: <4C451F3F.8000207@austin.ibm.com>
References: <4C451BF5.50304@austin.ibm.com>
	 <4C451F3F.8000207@austin.ibm.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 20 Jul 2010 12:23:04 -0700
Message-ID: <1279653784.9785.6.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-19 at 22:59 -0500, Nathan Fontenot wrote:
> 
> 
> -Now, XXX is defined as start_address_of_section / section_size.
> +Now, XXX is defined as (start_address_of_section / section_size) of
> the first
> +section conatined in the memory block.
> 
>  For example, assume 1GiB section size. A device for a memory starting
> at
>  0x100000000 is /sys/device/system/memory/memory4
>  (0x100000000 / 1Gib = 4)
>  This device covers address range [0x100000000 ... 0x140000000)
> 
> -Under each section, you can see 4 files.
> +Under each section, you can see 5 files.
> 
> -/sys/devices/system/memory/memoryXXX/phys_index
> +/sys/devices/system/memory/memoryXXX/start_phys_index
> +/sys/devices/system/memory/memoryXXX/end_phys_index 

Just wanted to make sure you didn't forget to update this after KAME's
comments on the first couple of patches.


-- Dave

