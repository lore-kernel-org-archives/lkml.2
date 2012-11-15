Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992589Ab2KOBan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 20:30:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:45196 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992498Ab2KOBak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 20:30:40 -0500
Message-ID: <50A4458E.5050601@infradead.org>
Date: Wed, 14 Nov 2012 17:29:50 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Rafael Aquini <aquini@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-mm@kvack.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm: balloon_compaction.c needs asm-generic/bug.h
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au> <50A43E64.3040709@infradead.org> <alpine.DEB.2.00.1211141729050.4749@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1211141729050.4749@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 05:29 PM, David Rientjes wrote:

> On Wed, 14 Nov 2012, Randy Dunlap wrote:
> 
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Fix build when CONFIG_BUG is not enabled by adding header file
>> <asm-generic/bug.h>:
>>
>> mm/balloon_compaction.c: In function 'balloon_page_putback':
>> mm/balloon_compaction.c:243:3: error: implicit declaration of function '__WARN'
>>
> 
> This is fixed by 
> mm-introduce-a-common-interface-for-balloon-pages-mobility-fix-fix-fix.patch 
> in -mm which converts it to WARN_ON(1) which is the generic way to trigger 
> a warning.
> --


OK, thanks for the info.

-- 
~Randy
