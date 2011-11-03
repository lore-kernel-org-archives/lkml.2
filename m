Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab1KCVWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:22:36 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:48084 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751942Ab1KCVWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:22:35 -0400
Message-ID: <4EB305F1.10600@xenotime.net>
Date: Thu, 03 Nov 2011 14:21:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, Dave Jones <davej@redhat.com>
Subject: Re: linux-next: Tree for Oct 25 (agp/intel-gtt.c)
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au> <4EA75596.3020301@xenotime.net>
In-Reply-To: <4EA75596.3020301@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 05:34 PM, Randy Dunlap wrote:
> On 10/25/11 02:36, Stephen Rothwell wrote:
>> Hi all,
> 
> 
> ERROR: "intel_iommu_gfx_mapped" [drivers/char/agp/intel-gtt.ko] undefined!
> 
> Full randconfig file is attached.


This still fails on linux-next of 2011-1102 (was it fixed for 1103?
I haven't checked those builds yet.)

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
