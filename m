Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082Ab2AFFEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 00:04:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42022 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2AFFEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 00:04:20 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=QcgJSxWpgi8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=RjEml0hsJoprBq_ynEcA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325826259.12696.66.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 06 Jan 2012 00:04:19 -0500
In-Reply-To: <20120101180949.GA25066@elte.hu>
References: <20111221123624.193898256@goodmis.org>
	 <20120101180949.GA25066@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-01 at 19:09 +0100, Ingo Molnar wrote:

> Hm, i'm seeing spontaneous reboot crashes with these commits 
> applied. The reboots just happen out of the blue during an 
> allyesconfig bootup (config attached), and they happen at
> random places.

Do you have any other configs that cause these crashes. One with less
options set. The config you have which is pretty much an allyesconfig
takes me 15 minutes to compile.

Thanks,


-- Steve


