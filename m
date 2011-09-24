Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab1IXBpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 21:45:43 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55951 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1IXBpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 21:45:42 -0400
Date: Sat, 24 Sep 2011 10:45:34 +0900
From: Tejun Heo <htejun@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org
Subject: Re: [PATCH] x86: use the same node_distance for 32 and 64-bit
Message-ID: <20110924014534.GY29319@htj.dyndns.org>
References: <201109191603.15560.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109191603.15560.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 04:03:14PM -0700, H Hartley Sweeten wrote:
> The node_distance function is not x86 64-bit specific.  Having the #ifdef
> around the extern function declaration and the #define causes the default
> node_distance macro to be used in asm-generic/topology.h. This also causes
> a sparse warning in arch/x86/mm/numa.c when CONFIG_X86_64 is not set:
> 
> warning: symbol '__node_distance' was not declared. Should it be static?
> 
> Remove the #ifdef to fix both issues.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
