Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1DFIT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 04:19:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:37219 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab1DFIT1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 04:19:27 -0400
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20110405 release
From: Peter Zijlstra <peterz@infradead.org>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org, Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Jason Wessel <jason.wessel@windriver.com>
In-Reply-To: <BANLkTinU5s8FgC9acCPcQqDRBnwi4EqA2g@mail.gmail.com>
References: <BANLkTin7=j8-feeJw5fqDsMd9BYrq09KbQ@mail.gmail.com>
	 <1302024458.2225.1350.camel@twins>
	 <BANLkTinU5s8FgC9acCPcQqDRBnwi4EqA2g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Apr 2011 10:19:19 +0200
Message-ID: <1302077959.2225.1378.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 13:54 +0800, Hui Zhu wrote:

> This is a good question.
> 
> The KGTP is completely different with KGDB.  It will not supply simple
> gdbrsp debug interface to user.  It just supply  interface between the
> kernel tracepoint(Now, just support kprobe, will add others later) and
> GDB tracepoint function.
> 
> So user can debug and trace Linux kernel with GDB without stop the
> Linux Kernel (So the GDB can running on this Kernel).  It is a trace
> tools and debug tools.

But this isn't really an answer either. Could you extend the existing
KGDB infrastructure to provide these features and thereby re-use
existing infrastructure to reduce your patch size and code duplication?

Jason (the KGDB maintainer) certainly thought there was much possibility
there when I spoke to him yesterday.

Think of it this way, wouldn't it be much better if there was one tool
that could provide the combined feature set of KGDB and KGTP?
