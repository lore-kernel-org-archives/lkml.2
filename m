Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab0EMAKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 20:10:50 -0400
Received: from ozlabs.org ([203.10.76.45]:44994 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab0EMAKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 20:10:49 -0400
Date: Thu, 13 May 2010 10:10:36 +1000
From: Paul Mackerras <paulus@samba.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@googlemail.com>
Subject: Re: [BUG] perf_event: when events are grouped, the time enabled /
 running values are incorrect
Message-ID: <20100513001036.GE11450@brick.ozlabs.ibm.com>
References: <4BE4C4BF.6020801@linux.vnet.ibm.com>
 <1273588935.1810.6.camel@laptop>
 <4BEAE476.1090100@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEAE476.1090100@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 10:25:10AM -0700, Corey Ashford wrote:

> Thanks for looking into this problem!  Unfortunately, I've been
> unable to test your patch.  It doesn't apply to 2.6.33.3 and so I
> tried the -tip tree (which has this patch committed).  The kernel
> built fine, but crashed almost immediately during the boot-up
> process on my Power5 machine.

Ugh.  I'll take a look today at that.

Paul.
