Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab0ERVNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:13:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40558 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab0ERVNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:13:35 -0400
Date: Tue, 18 May 2010 23:13:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
Message-ID: <20100518211328.GH22675@basil.fritz.box>
References: <20100518112509.GD22675@basil.fritz.box> <1274183935.5605.7726.camel@twins>> <4BF2C30F.6030502@zytor.com> <1274201536.5605.8347.camel@twins> <4BF2C881.60807@zytor.com> <1dc4abc2-6455-4b95-90f6-c86bf56ff39a@default> <4BF2E0A2.6030209@zytor.com> <dd1c0508-5570-4e65-89c0-4037eb210646@default> <61e3a205-b578-4972-a65a-b96f779aeeb1@default> <4BF2F9E4.8020808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF2F9E4.8020808@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not in favor of emulating rdtsc instructions.  I would consider
> letting them SIGILL (actually SIGSEGV since RDTSC #GP in userspace) when
> the TSC is unavailable, though.

I doubt we could ever do that, it would likely break just too much
code.  Yes the code is already broken likely on some system, but there's
a big difference between wrong time and crash.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
