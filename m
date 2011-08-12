Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab1HLQtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:49:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56280 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab1HLQts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:49:48 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=jTP-XjUXK6cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=XjXROemBD1dN12PN3FwA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 07/10] ktest: Introduce PASS_COUNT
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Jones <drjones@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1313155932-20092-8-git-send-email-drjones@redhat.com>
References: <1313155932-20092-1-git-send-email-drjones@redhat.com>
	 <1313155932-20092-8-git-send-email-drjones@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Aug 2011 12:49:45 -0400
Message-ID: <1313167785.18583.336.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 15:32 +0200, Andrew Jones wrote:
> Add another config variable that defines the number of times a test
> must pass before it really passes. This is good for boot tests, where
> the failure doesn't occur every time.

I'm curious to how this is really different than the ITERATE keyword.

That is, if we had:

TEST_START ITERATE 10
TEST_TYPE = test
TEST = ssh root@box "/work/runtest"

Hmm, is this to help in the bisects?

Maybe it should be called ITERATE as well, just to be consistent.

TEST_START
TEST_TYPE = bisect
ITERATE = 10

??

Or maybe that is confusing too, as that could be used to do the iterate
within the TEST_START (hmm, I may add that).

How about PASS_THRESHOLD? or PASS_COUNT_THRESHOLD? As I think that may
be more descriptive.

/me rereads his email and sees that he has a tendency to talk to
himself.


-- Steve


