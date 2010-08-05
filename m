Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183Ab0HELlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:41:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:42424 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760181Ab0HELli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:41:38 -0400
Message-ID: <4C5AA309.309@kernel.org>
Date: Thu, 05 Aug 2010 13:39:53 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>, akpm@linux-foundation.org
CC: lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] stop_machine: struct cpu_stopper, remove alignment padding
 on 64 bits
References: <1281006717.2000.12.camel@castor.rsk>
In-Reply-To: <1281006717.2000.12.camel@castor.rsk>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 05 Aug 2010 11:41:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/05/2010 01:11 PM, Richard Kennedy wrote:
> Reorder elements in structure cpu_stopper to remove alignment padding on
> 64 bit builds, this shrinks its size from 40 to 32 bytes saving 8 bytes
> per cpu.
> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Acked-by: Tejun Heo <tj@kernel.org>

Andrew, do you mind routing this one through your tree?

  http://lkml.org/lkml/2010/8/5/168

Thank you.

-- 
tejun
