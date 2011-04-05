Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1DENQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:16:07 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:62537 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab1DENQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:16:04 -0400
Message-ID: <4D9B1610.1060204@tilera.com>
Date: Tue, 5 Apr 2011 09:16:00 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: James Hogan <james@albanarts.com>
CC: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        James Hogan <james.hogan@imgtec.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paul Mundt <lethal@linux-sh.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-am33-list@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile,mn10300: add device parameter to dma_cache_sync()
References: <BANLkTi=wY2q49BRfZWempPRT7s=2Wa3YKQ@mail.gmail.com> <4D9A18F3.3090506@tilera.com> <20110404232001.GA14102@gandalf.le.imgtec.org>
In-Reply-To: <20110404232001.GA14102@gandalf.le.imgtec.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/2011 7:20 PM, James Hogan wrote:
> On Mon, Apr 04, 2011 at 03:16:03PM -0400, Chris Metcalf wrote:
>> On 4/4/2011 11:21 AM, James Hogan wrote:
>>> From: James Hogan <james.hogan@imgtec.com>
>>>
>>> Note: I'm not in a position to compile test this patch, but I don't
>>> foresee any problems.
>>>
>>> Since v2.6.20 "Pass struct dev pointer to dma_cache_sync()"
>>> (d3fa72e4556ec1f04e46a0d561d9e785ecaa173d), dma_cache_sync() takes a
>>> struct dev pointer, but these appear to be missing from the tile and
>>> mn10300 implementations, so add them.
>>>
>>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>>> ---
>>>  arch/mn10300/include/asm/dma-mapping.h |    2 +-
>>>  arch/tile/include/asm/dma-mapping.h    |    3 ++-
>>>  arch/tile/kernel/pci-dma.c             |    2 +-
>> assuming you're planning to push this up yourself.
> I'm not sure. I'm not that familiar with the process (my other patches
> tend to have just been picked up by other people).

I'll take it into my tree as well then.  Thanks.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

