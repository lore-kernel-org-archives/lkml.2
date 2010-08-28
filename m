Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab0H1P5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:57:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab0H1P5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:57:14 -0400
Message-ID: <4C7931CE.4050506@redhat.com>
Date: Sat, 28 Aug 2010 11:57:02 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm:  remove alignment padding from anon_vma on (some)
 64 bit builds
References: <1283004586.1912.10.camel@castor.rsk>
In-Reply-To: <1283004586.1912.10.camel@castor.rsk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2010 10:09 AM, Richard Kennedy wrote:
> Reorder structure anon_vma to remove alignment padding on 64 builds when
> (CONFIG_KSM || CONFIG_MIGRATION).
> This will shrink the size of the anon_vma structure from 40 to 32 bytes
> &  allow more objects per slab in its kmem_cache.
>
> Under slub the objects in the anon_vma kmem_cache will then be 40 bytes
> with 102 objects per slab.
> (On v2.6.36 without this patch,the size is 48 bytes and 85
> objects/slab.)
>
> compiled&  tested on x86_64 using SLUB
>
> Signed-off-by: Richard Kennedy<richard@rsk.demon.co.uk>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
