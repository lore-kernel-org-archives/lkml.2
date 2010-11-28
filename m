Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab0K1CEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 21:04:09 -0500
Received: from smtp-out.google.com ([216.239.44.51]:22231 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab0K1CEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 21:04:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=P1ToMsKJdIgGRN0dPYVIRL7K/OCkDXqLcnYHNfv7Ke4CxFu0SwV3uZSa7ubqCKjyQs
         VEP8jYbzm8dyejbTM+Dw==
Date: Sat, 27 Nov 2010 18:03:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: akpm@linux-foundation.org, gregkh@suse.de, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, lethal@linux-sh.org, ak@linux.intel.com,
        yinghai@kernel.org, randy.dunlap@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        haicheng.li@intel.com, haicheng.li@linux.intel.com
Subject: Re: [patch 1/2] x86: add numa=possible command line option
In-Reply-To: <20101122022411.GC9081@shaohui>
Message-ID: <alpine.DEB.2.00.1011271802210.3764@chino.kir.corp.google.com>
References: <A24AE1FFE7AEC5489F83450EE98351BF28723FC48C@shsmsx502.ccr.corp.intel.com> <20101122022411.GC9081@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010, Shaohui Zheng wrote:

> It is the improved solution from thread http://lkml.org/lkml/2010/11/18/3,
> our draft patch set all the nodes as possbile node, it wastes a lot of memory,
> the command line numa=possible=<N> seems to be an acceptable, and it is a optimization
> for our patch.
> 

node_possible_map is a generic nodemask used throughout the kernel, but 
its handling is highly dependent on the arch.  This patch enables the 
support for x86, I'd encourage anyone else interested in other archs to 
look into adding the support for it as well (perhaps you can do it for 
powerpc?).

> I like your active work attitude for the patch reviewing, it is real helpful to 
> improve the patch quality.
> 

Thanks, I'm happy to be involved!
