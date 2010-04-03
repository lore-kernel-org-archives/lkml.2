Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab0DCIet (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 04:34:49 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39693 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab0DCIer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 04:34:47 -0400
Message-ID: <4BB6FDA1.3070502@in.ibm.com>
Date: Sat, 03 Apr 2010 14:04:41 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: 2.6.34-rc3: Badness at kernel/lockdep.c:2706
References: <4BB588B5.1060309@in.ibm.com> <1270218533.5109.525.camel@twins> <m14ojtrjbv.fsf@fess.ebiederm.org>
In-Reply-To: <m14ojtrjbv.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Could you try the fix Wolfram Sang sent to linux-kernel yesterday?
>   
Yes that fixed the issue for me. Thanks Eric.

Regards
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

