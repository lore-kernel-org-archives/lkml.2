Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab1FGVmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:42:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57639 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1FGVmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:42:07 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=sf8ITmforAUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=K2bVxwJ-O2-rZGGjw4cA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/3 v2] ftrace: Revert 8ab2b7efd ftrace: Remove
 unnecessary disabling of
From: Steven Rostedt <rostedt@goodmis.org>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20110607213850.GG28762@amd.home.annexia.org>
References: <20110607212937.662660421@goodmis.org>
	 <20110607213007.577456514@goodmis.org>
	 <20110607213850.GG28762@amd.home.annexia.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Jun 2011 17:42:06 -0400
Message-ID: <1307482926.9218.11.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 22:38 +0100, Richard W.M. Jones wrote:
> On Tue, Jun 07, 2011 at 05:29:40PM -0400, Steven Rostedt wrote:

> > 1.7.4.4
> 
> ACK as before.

I added your tested by, but never added your Acked-by. Sorry :-p

-- Steve



