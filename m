Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab0CXToA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:44:00 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:55699 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab0CXTn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:43:58 -0400
Date: Wed, 24 Mar 2010 14:42:56 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com, mingo@elte.hu,
       adobriyan@gmail.com, tglx@linutronix.de, hpa@zytor.com,
       yi.zhu@intel.com, reinette.chatre@intel.com, ilw@linux.intel.com,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/4] include cleanup: Update gfp.h and slab.h includes
 to prepare for breaking implicit slab.h inclusion from percpu.h
In-Reply-To: <1269420538-18039-4-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.00.1003241425060.14329@router.home>
References: <1269420538-18039-1-git-send-email-tj@kernel.org> <1269420538-18039-4-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010, Tejun Heo wrote:

>   http://userweb.kernel.org/~tj/misc/slabh-sweep.py

Ugg. What a complex beast.

> With the actual patch, this message would end up ~1.7M which seems tad
> bit too large to send through LKML.  I said that I would post the
> whole patch on the last round but that was 200k and this one is 272K
> only with the diffstats and this one doesn't include any interesting
> stuff, so I'm snipping it again.  The whole patch is available at the
> following URL.

Sounds all okay. But reviewing the actual patch. How?

Guess-its-ok-by: Christoph Lameter <cl@linux-foundation.org>

