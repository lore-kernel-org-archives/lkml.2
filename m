Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab2I1Cyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 22:54:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36109 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482Ab2I1Cyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 22:54:37 -0400
Message-ID: <50651163.5050101@zytor.com>
Date: Thu, 27 Sep 2012 19:54:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cote <david.m.cote@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Chaohong Guo <chaohong.guo@intel.com>,
        Austin Zhang <austin_zhang@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>, Min Li <min.a.li@intel.com>
Subject: Re: [PATCH 0/3 v2] Optimize CRC32C calculation using PCLMULQDQ in
 crc32c-intel module
References: <cover.1348784343.git.tim.c.chen@linux.intel.com> <1348785854.17632.15.camel@schen9-DESK>
In-Reply-To: <1348785854.17632.15.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 03:44 PM, Tim Chen wrote:
> Version 2
> This version of the patch series fixes compilation errors for
> 32 bit x86 targets.
>
> Version 1
> This patch series optimized CRC32C calculations with PCLMULQDQ
> instruction for crc32c-intel module.  It speeds up the original
> implementation by 1.6x for 1K buffer and by 3x for buffer 4k or
> more.  The tcrypt module was enhanced for doing speed test
> on crc32c calculations.
>

Herbert - you are handling this one, right?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

