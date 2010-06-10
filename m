Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab0FJLQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:16:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:34715 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab0FJLQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:16:21 -0400
Message-ID: <4C10C930.9080900@kernel.org>
Date: Thu, 10 Jun 2010 13:14:56 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/23] x86: percpu: Avoid warnings of unused variables
 in per cpu
References: <20100610110.764742110@firstfloor.org> <20100610111036.DAE8EB1A2C@basil.firstfloor.org>
In-Reply-To: <20100610111036.DAE8EB1A2C@basil.firstfloor.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Jun 2010 11:14:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 01:10 PM, Andi Kleen wrote:
> Avoid hundreds of warnings with a gcc 4.6 -Wall build
> 
> Cc: tj@kernel.org
> Cc: x86@kernel.org
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Tejun Heo <tj@kernel.org>

Can x86 or -mm please take this patch?  There isn't any pending percpu
patch currently and it seems a bit silly to start a branch for this
one.

Thanks.

-- 
tejun
