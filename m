Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0HIN5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 09:57:16 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46829 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab0HIN5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 09:57:15 -0400
Message-ID: <4C600923.3030401@austin.ibm.com>
Date: Mon, 09 Aug 2010 08:56:51 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] v4 Update the find_memory_block declaration
References: <4C581A6D.9030908@austin.ibm.com>	<4C581C99.8090201@austin.ibm.com> <20100805135944.97ecbaa4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100805135944.97ecbaa4.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 11:59 PM, KAMEZAWA Hiroyuki wrote:
> On Tue, 03 Aug 2010 08:41:45 -0500
> Nathan Fontenot <nfont@austin.ibm.com> wrote:
> 
>> Update the find_memory_block declaration to to take a struct mem_section *
>> so that it matches the definition.
>>
>> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Hmm...my mmotm-0727 has this definition in memory.h...
> 
> extern struct memory_block *find_memory_block(struct mem_section *);
> 
> What patch makes it unsigned long ?
> 

I was basing the patches on the latest mainline tree.  Looks like  can drop
this patch in the next version of the patchset.

-Nathan
