Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0HZSRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:17:24 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50290 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab0HZSRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:17:22 -0400
Message-ID: <4C76AFA2.8010801@cs.helsinki.fi>
Date: Thu, 26 Aug 2010 21:17:06 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Christoph Lameter <cl@linux.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-mm@kvack.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 25 (mm/slub)
References: <20100825132057.c8416bef.sfr@canb.auug.org.au>	<20100825094559.bc652afe.randy.dunlap@oracle.com>	<alpine.DEB.2.00.1008251409260.22117@router.home>	<20100825122134.2ac33360.randy.dunlap@oracle.com>	<alpine.DEB.2.00.1008251447410.22117@router.home> <20100825131344.a2c26b31.randy.dunlap@oracle.com>
In-Reply-To: <20100825131344.a2c26b31.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.8.2010 23.13, Randy Dunlap wrote:
> On Wed, 25 Aug 2010 14:51:14 -0500 (CDT) Christoph Lameter wrote:
>
>> On Wed, 25 Aug 2010, Randy Dunlap wrote:
>>
>>> Certainly.  config file is attached.
>>
>> Ah. Memory hotplug....
>>
>>
>>
>> Subject: Slub: Fix up missing kmalloc_cache ->  kmem_cache_node case for memoryhotplug
>>
>> Memory hotplug allocates and frees per node structures. Use the correct name.
>>
>> Signed-off-by: Christoph Lameter<cl@linux.com>
>
> Acked-by: Randy Dunlap<randy.dunlap@oracle.com>

Applied, thanks!
