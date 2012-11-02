Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2KBUvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:51:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17087 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2KBUvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:51:53 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wowpZ7sFJ74A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Z-wZqcGM7j4A:10 a=ucbKnPDZcEvcC2zOOc4A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351889510.4004.149.camel@gandalf.local.home>
Subject: Re: [PATCH 00/32] [RFC] nohz/cpuset: Start discussions on nohz CPUs
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>
Date: Fri, 02 Nov 2012 16:51:50 -0400
In-Reply-To: <20121102204157.GE3027@linux.vnet.ibm.com>
References: <20121029202711.062749374@goodmis.org>
	 <0000013ac180f152-79f05c71-4d38-43b0-9b62-8a71c00dfda7-000000@email.amazonses.com>
	 <1351867045.4004.141.camel@gandalf.local.home>
	 <0000013ac1a58555-bea33420-d101-4e86-abc5-11dd6863b7a8-000000@email.amazonses.com>
	 <20121102183544.GZ3027@linux.vnet.ibm.com>
	 <0000013ac2c4f47a-d21f2685-6660-4d02-872d-581d203285a0-000000@email.amazonses.com>
	 <20121102204157.GE3027@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 13:41 -0700, Paul E. McKenney wrote:

> The no-CBs mask would be read-only for some time -- changed only at
> boot.  Longer term, I hope to allow run-time modification, but...
> 

but what? You're not looking to retire already are you? ;-)

-- Steve


