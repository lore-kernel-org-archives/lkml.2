Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab1HSPOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:14:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57245 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab1HSPOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:14:03 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=WAcKz-GHrqMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=2E1FBEUPP2zffjyzBRwA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/3] trace points: power: remove 'cpu_id' from
 trace_clock_*
From: Steven Rostedt <rostedt@goodmis.org>
To: tom.leiming@gmail.com
Cc: fweisbec@gmail.com, jean.pihet@newoldbits.com, mingo@redhat.com,
        trenn@suse.de, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <1313766244-22313-1-git-send-email-tom.leiming@gmail.com>
References: <1313766244-22313-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 19 Aug 2011 11:14:00 -0400
Message-ID: <1313766840.15704.104.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-19 at 23:04 +0800, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch removes the 'cpu_id' parameter of the clock_*
> trace point, based on the ideas below:
> 
> - the cpu_id which is passed to trace point is always the current
>   cpu
> - the current cpu info has been included into the trace result already
> - smp_processor_id() can't be used safely in preemptible context.
> 

Do you know if these changes wont break powertop?

-- Steve


