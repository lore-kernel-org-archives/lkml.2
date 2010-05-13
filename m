Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab0EMKRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:17:15 -0400
Received: from ozlabs.org ([203.10.76.45]:52125 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758431Ab0EMKRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:17:14 -0400
Date: Thu, 13 May 2010 20:17:03 +1000
From: Paul Mackerras <paulus@samba.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@googlemail.com>
Subject: Re: [BUG] perf_event: when events are grouped, the time enabled /
 running values are incorrect
Message-ID: <20100513101703.GA15387@brick.ozlabs.ibm.com>
References: <4BE4C4BF.6020801@linux.vnet.ibm.com>
 <1273588935.1810.6.camel@laptop>
 <4BEAE476.1090100@linux.vnet.ibm.com>
 <20100513001036.GE11450@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513001036.GE11450@brick.ozlabs.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 10:10:36AM +1000, Paul Mackerras wrote:

> Ugh.  I'll take a look today at that.

Current tip/perf/core boots up just fine for me on a POWER5+ partition
here.  If you're still seeing the problem, could you send me your
config?

Paul.
