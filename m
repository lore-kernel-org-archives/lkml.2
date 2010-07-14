Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab0GNLrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 07:47:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:49698 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab0GNLrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:47:08 -0400
Message-ID: <4C3DA38A.7010003@kernel.org>
Date: Wed, 14 Jul 2010 13:46:18 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>
Subject: Re: [S+Q2 00/19] SLUB with queueing (V2) beats SLAB netperf TCP_RR
References: <20100709190706.938177313@quilx.com> <20100710195621.GA13720@fancy-poultry.org> <alpine.DEB.2.00.1007121010420.14328@router.home>
In-Reply-To: <alpine.DEB.2.00.1007121010420.14328@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Jul 2010 11:46:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/12/2010 05:11 PM, Christoph Lameter wrote:
> You need a sufficient PERCPU_DYNAMIC_EARLY_SIZE to be configured. What
> platform is this? Tejon: You suggested the BUILD_BUG_ON(). How can he
> increase the early size?

The size is determined by PERCPU_DYNAMIC_EARLY_SIZE, so bumping it up
should do it but it would probably be wiser to bump
PERCPU_DYNAMIC_RESERVE too.  PERCPU_DYNAMIC_EARLY_SIZE is currently
12k.  How high should it be?

Thanks.

-- 
tejun
