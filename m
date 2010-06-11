Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0FKFcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 01:32:43 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37233 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab0FKFcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 01:32:42 -0400
Message-ID: <4C11CA71.9010606@in.ibm.com>
Date: Fri, 11 Jun 2010 11:02:33 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: 2.6.35-rc2: GPF while executing libhugetlbfs tests on x86_64
References: <4C0BC7F0.8030109@in.ibm.com> <20100608091817.GA27717@csn.ul.ie> <4C0E2E84.6060605@in.ibm.com> <20100608123622.GE27717@csn.ul.ie>
In-Reply-To: <20100608123622.GE27717@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> If the problem has gone away since 2.6.35-rc2, the most likely candidate fix
> patch is commit [386f40: Revert "tty: fix a little bug in scrup, vt.c"] which
> reverts the patch you previously identified as being a problem.  The commit
> message also matches roughly what you are seeing with the 0x0720 patterns.
>
> Can you retest with 2.6.35-rc2 with commit 386f40 applied and see if it
> also fixes up your problem please?
>   
I could not recreate this problem against 2.6.35-rc2 + commit 386f40.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

