Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab2LMPRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:17:50 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61123 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab2LMPRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:17:49 -0500
Message-ID: <50C9F19D.8060209@gmail.com>
Date: Thu, 13 Dec 2012 10:17:49 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH] mm: add node physical memory range to sysfs
References: <1354919696.2523.6.camel@buesod1.americas.hpqcorp.net> <20121207155125.d3117244.akpm@linux-foundation.org> <50C28720.3070205@linux.vnet.ibm.com> <1355361524.5255.9.camel@buesod1.americas.hpqcorp.net> <50C933E9.2040707@linux.vnet.ibm.com> <1355364222.9244.3.camel@buesod1.americas.hpqcorp.net> <50C95E4A.9010509@linux.vnet.ibm.com>
In-Reply-To: <50C95E4A.9010509@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/12/12 11:49 PM), Dave Hansen wrote:
> On 12/12/2012 06:03 PM, Davidlohr Bueso wrote:
>> On Wed, 2012-12-12 at 17:48 -0800, Dave Hansen wrote:
>>> But if we went and did it per-DIMM (showing which physical addresses and
>>> NUMA nodes a DIMM maps to), wouldn't that be redundant with this
>>> proposed interface?
>>
>> If DIMMs overlap between nodes, then we wouldn't have an exact range for
>> a node in question. Having both approaches would complement each other.
> 
> How is that possible?  If NUMA nodes are defined by distances from CPUs
> to memory, how could a DIMM have more than a single distance to any
> given CPU?

numa_emulation? just guess.



