Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1HLRUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:20:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47098 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1HLRUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:20:40 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=jTP-XjUXK6cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Af_5r3cNoReI0n-iaPsA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 07/10] ktest: Introduce PASS_COUNT
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Jones <drjones@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110812170958.GA18363@turtle.usersys.redhat.com>
References: <1313155932-20092-1-git-send-email-drjones@redhat.com>
	 <1313155932-20092-8-git-send-email-drjones@redhat.com>
	 <1313167785.18583.336.camel@gandalf.stny.rr.com>
	 <20110812170958.GA18363@turtle.usersys.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Aug 2011 13:20:39 -0400
Message-ID: <1313169639.18583.344.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 19:09 +0200, Andrew Jones wrote:

> > How about PASS_THRESHOLD? or PASS_COUNT_THRESHOLD? As I think that may
> > be more descriptive.
> 
> PASS_THRESHOLD sounds good. Should I respin with that change now? Or are
> you still considering a different design?
> 

Nah, thinking about it more, I don't like PASS_THRESHOLD either. Maybe
we should have a RERUN option. That is, RERUN the test for each
iteration?

-- Steve


