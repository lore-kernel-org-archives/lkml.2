Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab0EMJDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 05:03:14 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42266 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab0EMJDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 05:03:13 -0400
Message-ID: <4BEBBF7E.30500@vflare.org>
Date: Thu, 13 May 2010 14:29:42 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] Cleanup migrate case in try_to_unmap_one
References: <20100513144336.216D.A69D9226@jp.fujitsu.com> <4BEBA70C.9050404@vflare.org> <20100513163441.2176.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100513163441.2176.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 01:36 PM, KOSAKI Motohiro wrote:
>> On 05/13/2010 11:34 AM, KOSAKI Motohiro wrote:
>>>> Remove duplicate handling of TTU_MIGRATE case for
>>>> anonymous and filesystem pages.
>>>>
>>>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>>>
>>> This patch change swap cache case. I think this is not intentional.
>>
>> IIUC, we never call this function with TTU_MIGRATE for swap cache pages.
>> So, the behavior after this patch remains unchanged.
> 
> Why?
> 
> 


Kindly ignore. Looks like I misunderstood this part.
Sorry for the trouble.

Nitin

