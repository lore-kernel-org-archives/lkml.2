Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab0FPRtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 13:49:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:50460 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab0FPRs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 13:48:58 -0400
Subject: Re: [RFC][PATCH 4/8] perf: Unindent labels
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100616171611.GB5530@nowhere>
References: <20100616160027.590430763@chello.nl>
	 <20100616160238.347022826@chello.nl>  <20100616171611.GB5530@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Jun 2010 19:48:43 +0200
Message-ID: <1276710523.1745.609.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 19:16 +0200, Frederic Weisbecker wrote:

> The point in having a space before the label starts is that it doesn't
> appear as a function boundary in patches.
> 
> This avoid patches that look like:
> 
> @@ -xxx +yyy @@ out:
> -	blah
> 

Yeah, fix diff already ;-)
