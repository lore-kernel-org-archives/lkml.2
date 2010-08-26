Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab0HZSRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:17:05 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50290 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab0HZSRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:17:03 -0400
Message-ID: <4C76AF8D.2030507@cs.helsinki.fi>
Date: Thu, 26 Aug 2010 21:16:45 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: David Rientjes <rientjes@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (slab
 tree related)
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <20100825101320.bed89b2a.sfr@canb.auug.org.au> <4C74A01E.1060809@cs.helsinki.fi> <alpine.DEB.2.00.1008250905490.13026@router.home> <alpine.DEB.2.00.1008251656390.22018@chino.kir.corp.google.com> <alpine.DEB.2.00.1008252031560.32421@router.home> <alpine.DEB.2.00.1008252014560.10986@chino.kir.corp.google.com> <alpine.DEB.2.00.1008260938360.16331@router.home>
In-Reply-To: <alpine.DEB.2.00.1008260938360.16331@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.8.2010 17.41, Christoph Lameter wrote:
> On Wed, 25 Aug 2010, David Rientjes wrote:
>
>> I'm really hoping that we can remove this hack soon when the percpu
>> allocator can handle these allocations on UP without any specialized slab
>> behavior.
>
> So do I. Here is a slightly less hacky version through using
> kmalloc_large instead:

Applied and queued to -next.
