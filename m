Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab0DAHcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:32:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:50346 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab0DAHcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:32:08 -0400
Message-ID: <4BB44BED.4060501@kernel.org>
Date: Thu, 01 Apr 2010 16:31:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, sjur.brandeland@stericsson.com,
       netdev@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the slabh tree
References: <20100401164110.80e3b18f.sfr@canb.auug.org.au> <20100401.002908.267643090.davem@davemloft.net>
In-Reply-To: <20100401.002908.267643090.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 01 Apr 2010 07:32:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 04:29 PM, David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 1 Apr 2010 16:41:10 +1100
> 
>> I have applied the following patch for today.  Dave, could you apply this
>> to the net tree please?
> 
> Done.

Thanks!

-- 
tejun
