Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab1LGPAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:00:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107Ab1LGPAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:00:14 -0500
Date: Wed, 7 Dec 2011 09:59:48 -0500
From: Don Zickus <dzickus@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        robert.richter@amd.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [patch] x86, NMI: add to_cpumask() to silence compile warning
Message-ID: <20111207145948.GA1669@redhat.com>
References: <1318533267-18880-3-git-send-email-dzickus@redhat.com>
 <tip-99e8b9ca90d688c3ac7d3a141b701c9694a93925@git.kernel.org>
 <20111206090612.GA18662@elte.hu>
 <20111206180859.GR1669@redhat.com>
 <20111207110612.GA3437@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111207110612.GA3437@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 02:06:12PM +0300, Dan Carpenter wrote:
> Gcc complains if we don't cast this to a struct cpumask pointer.
> arch/x86/kernel/nmi_selftest.c:93:2:
> 	warning: passing argument 1 of ‘cpumask_empty’ from
> 	incompatible pointer type [enabled by default]
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Crap, I knew I rushed the patch.  Thanks for catching this obvious bug.

Acked-by: Don Zickus <dzickus@redhat.com>
