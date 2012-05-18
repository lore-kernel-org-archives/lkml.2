Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761814Ab2ERL3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 07:29:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:55688 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760206Ab2ERL3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 07:29:19 -0400
Message-ID: <1337340552.573.33.camel@twins>
Subject: Re: [PATCH] perf, x86: Update event scheduling constraints for AMD
 family 15h models
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Date: Fri, 18 May 2012 13:29:12 +0200
In-Reply-To: <1337337642-1621-1-git-send-email-robert.richter@amd.com>
References: <1337337642-1621-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 12:40 +0200, Robert Richter wrote:
> +               case 0x031:
> +                       if (hweight_long(hwc->config & ARCH_PERFMON_EVENTSEL_UMASK) <= 1)
> +                               return &amd_f15_PMC20;
> +                       return &emptyconstraint;
> +               case 0x1C0:
> +                       return &amd_f15_PMC53; 

Oh man, that's just vile.. I hope you've given your hardware team a big
hug for this.. :-)
