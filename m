Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab1GEMuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:50:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55512 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab1GEMud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:50:33 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=WrRwyXlJCEoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=9wsImS4Ea_lzOaCtx04A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [patch 10/11] sh/unicore32/irqs: Do not trace
 arch_local_{*,irq_*} functions
From: Steven Rostedt <rostedt@goodmis.org>
To: gxt@mprc.pku.edu.cn
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1309744599.2291.1.camel@epip-laptop>
References: <20110702030435.308336775@goodmis.org>
	 <20110702033854.432833160@goodmis.org>
	 <1309744599.2291.1.camel@epip-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 05 Jul 2011 08:50:30 -0400
Message-ID: <1309870230.26417.171.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 09:56 +0800, Guan Xuetao wrote:
> It looks good to me.
> 
> Thanks & Regards.
> 

Thanks!

Are you or Paul going to pull it into the sh tree?

-- Steve


