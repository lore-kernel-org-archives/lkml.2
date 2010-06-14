Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0FNCmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 22:42:08 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35354 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab0FNCmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 22:42:06 -0400
Subject: Re: Tracing configuration review
From: Chase Douglas <chase.douglas@canonical.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Soeren Sandmann <sandmann@daimi.au.dk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com
In-Reply-To: <20100611145116.72c88387.randy.dunlap@oracle.com>
References: <1274815906.9757.83.camel@cndougla-ubuntu>
	 <20100525201259.GA5370@nowhere> <1274821799.9346.17.camel@cndougla-ubuntu>
	 <20100608103517.ac380ad4.randy.dunlap@oracle.com>
	 <1276034434.8645.56.camel@cndougla-ubuntu>
	 <20100611145116.72c88387.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Jun 2010 22:41:30 -0400
Message-ID: <1276483290.1943.80.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 14:51 -0700, Randy Dunlap wrote:
> I'm a bit surprised by one (family) of kconfig symbols here:
> 
> PM_TRACE=y, PM_TRACE_RTC=y
> 
> That enables low-level kernel developer debugging code.
> 
> Other than that, the rest make sense to me.

We try to focus a lot on the laptop use case, and so we do a bit of work
on suspend/resume bugs. For those unaware, these options allow one to
save the very last PM event point inside the RTC. If a suspend dies we
may be able to get some good information on where it died using this
tool. The functionality has to be manually enabled at runtime, otherwise
the RTC would get scribbled over during every resume. Since it doesn't
have any impact in the general use case, we leave it enabled by default.
We already build too many test kernels for other types of bugs :).

Thanks,

-- Chase

