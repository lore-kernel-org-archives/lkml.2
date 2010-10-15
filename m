Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750913Ab0JOEAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:00:43 -0400
Received: from outmail148114.authsmtp.net ([62.13.148.114]:53502 "EHLO
	outmail148114.authsmtp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780Ab0JOEAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:00:41 -0400
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Oct 2010 00:00:41 EDT
From: Ben Pfaff <blp@cs.stanford.edu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Bruno Randolf <br1@einfach.org>, linux-kernel@vger.kernel.org,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add generic exponentially weighted moving average function
References: <20101006093225.8739.14012.stgit@tt-desk>
	<20101012173352.0a458c24.randy.dunlap@oracle.com>
Reply-To: Ben Pfaff <blp@cs.stanford.edu>
Date: Thu, 14 Oct 2010 20:40:24 -0700
In-Reply-To: <20101012173352.0a458c24.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Tue, 12 Oct 2010 17:33:52 -0700")
Message-ID: <87y6a0unrr.fsf@benpfaff.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Server-Quench: f3967a4f-d80d-11df-80b9-0022640b883e
X-AuthReport-Spam: If SPAM / abuse - report it at: http://www.authsmtp.com/abuse
X-AuthRoute: OCdwYQ8QAVZfSBwy AC4CFCFJRwtjIQdD FxoeKRdbOF4EFVgQ JB8HaX1YLBpGHQgB E2YPUVBUWl92F2Rz dQtVcwFVfEhOXRpo VUpMXVMcSwweAklh YX4eVBFxdwAIcHpz ZQg0XXldWxV+I1sp Sk4ACGwHMTF9YGBN WV1YdwFWdgdKLBdN aQUxNiYHcQ5nFx4T Pzp7Fjw9dTpSLilP QwpFIEIKRkAGGCI9 ThQGDH0wEEwKRzk+ I1QjLUAdGklZO1s/ K1IuVBoWLhkZFgxZ GSkA
X-Authentic-SMTP: 61633331373532.1015:706
X-AuthFastPath: 255
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> writes:

> On Wed, 06 Oct 2010 18:32:25 +0900 Bruno Randolf wrote:
>
>> This adds a generic exponentially weighted moving average function. This
>> implementation makes use of a structure which keeps a scaled up internal
>> representation to reduce rounding errors.
>> 
>> The idea for this implementation comes from the rt2x00 driver (rt2x00link.c)
>> and i would like to use it in several places in the mac80211 and ath5k code.
>
> I guess I don't understand "exponentially weighted" or why that would
> be desirable.  Please try to explain (briefly).

I wrote up a fairly non-brief explanation of exponentially
weighted moving averages a few years ago:
        http://www.stanford.edu/class/cs140/projects/pintos/pintos_7.html#SEC134
-- 
Ben Pfaff 
http://benpfaff.org
