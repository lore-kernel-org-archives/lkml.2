Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab0E3KFQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 06:05:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39902 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab0E3KFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 06:05:14 -0400
Message-ID: <4C023854.3090002@cs.helsinki.fi>
Date: Sun, 30 May 2010 13:05:08 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [BUG] slub crashes on dma allocations
References: <20100526153757.GB2232@osiris.boeblingen.de.ibm.com> <alpine.DEB.2.00.1005270916220.5762@router.home> <20100527190440.GA2205@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100527190440.GA2205@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Thu, May 27, 2010 at 09:17:17AM -0500, Christoph Lameter wrote:
>> So S390 has NUMA and the minalign is allowing very small slabs of 8/16/32 bytes?
> 
> No NUMA, but minalign is 8.
> 
>> Try this patch
>>
>> From: Christoph Lameter <cl@linux-foundation.org>
>> Subject: SLUB: Allow full duplication of kmalloc array for 390
>>
>> Seems that S390 is running out of kmalloc caches.
>>
>> Increase the number of kmalloc caches to a safe size.
>>
>> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> Yes, that fixes the bug. Thanks!

We need this for .33 and .34 stable, right?
