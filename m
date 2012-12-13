Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab2LMBso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:48:44 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:40310 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2LMBsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:48:43 -0500
Message-ID: <50C933E9.2040707@linux.vnet.ibm.com>
Date: Wed, 12 Dec 2012 17:48:25 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: add node physical memory range to sysfs
References: <1354919696.2523.6.camel@buesod1.americas.hpqcorp.net> <20121207155125.d3117244.akpm@linux-foundation.org> <50C28720.3070205@linux.vnet.ibm.com> <1355361524.5255.9.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1355361524.5255.9.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121301-4834-0000-0000-0000017140F9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 05:18 PM, Davidlohr Bueso wrote:
> On Fri, 2012-12-07 at 16:17 -0800, Dave Hansen wrote:
>> Seems like the better way to do this would be to expose the DIMMs
>> themselves in some way, and then map _those_ back to a node.
> 
> Good point, and from a DIMM perspective, I agree, and will look into
> this. However, IMHO, having the range of physical addresses for every
> node still provides valuable information, from a NUMA point of view. For
> example, dealing with node related e820 mappings.

But if we went and did it per-DIMM (showing which physical addresses and
NUMA nodes a DIMM maps to), wouldn't that be redundant with this
proposed interface?

How do you plan to use this in practice, btw?

