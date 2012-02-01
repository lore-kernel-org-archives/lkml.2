Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab2BAJvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 04:51:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab2BAJvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 04:51:13 -0500
Message-ID: <4F290BA8.9030606@redhat.com>
Date: Wed, 01 Feb 2012 17:53:44 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] move vm tools from Documentation/vm/ to tools/
References: <20120201063420.GA10204@darkstar.nay.redhat.com>	<CAOJsxLGVS3bK=hiKJu4NwTv-Nf8TCSAEL4reSZoY4=44hPt8rA@mail.gmail.com>	<4F28EC9D.7000907@redhat.com>	<20120201083032.GA6774@localhost> <CAOJsxLEnn-5X5q=1p07twxm5EuyQo7cOBBfFQXUeMGi3Pvd46w@mail.gmail.com>
In-Reply-To: <CAOJsxLEnn-5X5q=1p07twxm5EuyQo7cOBBfFQXUeMGi3Pvd46w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 04:44 PM, Pekka Enberg wrote:

> On Wed, Feb 1, 2012 at 10:30 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> Will git-mv end up with a better commit?
> 
> Just use
> 
>     git format-patch -C


good idea, patch looks clean with -C. So there should be no much problem
for review. Also because there's also Makefile changes, I want to still
send as one patch with all changes. How do you think?

> 
> to generate the patch and it should be fine.
> 
>>> BTW, I think tools/slub/slabinfo.c should be included in tools/vm/ as
>>> well, will move it in v2 patch
>>
>> CC Christoph. Maybe not a big deal since it's already under tools/.
> 
> I'm certainly fine with moving it to tools/vm.



-- 
Thanks
Dave
