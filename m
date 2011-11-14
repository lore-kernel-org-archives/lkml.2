Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1KNPUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 10:20:36 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:40160 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab1KNPUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 10:20:35 -0500
Message-ID: <4EC131A3.9050504@parallels.com>
Date: Mon, 14 Nov 2011 19:20:03 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Adrian Reber <adrian@lisas.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Oren Laadan <orenl@cs.columbia.edu>,
        "matt.helsley@gmail.com" <matt.helsley@gmail.com>,
        =?ISO-8859-1?Q?Peter_?= =?ISO-8859-1?Q?V=E4terlein?= 
	<Peter.Vaeterlein@hs-esslingen.de>
Subject: Re: linux-cr ported to 3.2-rc1
References: <20111114151300.GT16442@lisas.de>
In-Reply-To: <20111114151300.GT16442@lisas.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2011 07:13 PM, Adrian Reber wrote:
> I have ported the linux-cr patches from www.linux-cr.org/pub/git/linux-cr.git
> to the latest kernel (3.2-rc1). The tests (on x86_64) I have done so far
> were successful. My repository with the C/R patches on top of 3.2-rc1 is
> currently at:
> 
> http://lisas.de/~adrian/linux-cr.git
> 
> 
> The development on the linux-cr tree hast stopped sometime around 2.6.37
> and although those patches have gone through many revisions I am not sure
> about the latest state of those patches concerning inclusion. At what
> point has the discussion stopped and why?

AFAIK very few people from the community support the idea of having the C/R
functionality implemented as the kernel subsystem.

> I have seen patches from Pavel about another approach for 
> checkpointing/restarting but I haven't heard anything about
> that during the last months.
> 
> What are the chances to get one of the checkpointing/restarting
> implementations included. What is still missing from the one I used?

The chances are ... quite high. We implement our C/R code in the userspace
and require very few pieces from kernel. So far 2 out of 3 proposed API
extensions were merged into -mm tree.

> What is the latest state of Pavel's patches?

The state right now is - we can dump and restore tasks with any types of
memory, open regular files and pipes with its contents. The code is currently 
under internal review process. We're going to send the public RFC early next 
week. Then go on with more resources to dump and restore.

> 		Adrian
> .
> 

