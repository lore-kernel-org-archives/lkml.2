Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab1KOS2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 13:28:45 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:41273 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141Ab1KOS2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 13:28:44 -0500
Date: Tue, 15 Nov 2011 18:29:44 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Adrian Reber <adrian@lisas.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oren Laadan <orenl@cs.columbia.edu>,
        "matt.helsley@gmail.com" <matt.helsley@gmail.com>,
        Peter =?iso-8859-1?Q?V=E4terlein?= 
	<Peter.Vaeterlein@hs-esslingen.de>
Subject: Re: linux-cr ported to 3.2-rc1
Message-ID: <20111115182944.GA16212@hallyn.com>
References: <20111114151300.GT16442@lisas.de>
 <4EC131A3.9050504@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC131A3.9050504@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@parallels.com):
> On 11/14/2011 07:13 PM, Adrian Reber wrote:
> > I have ported the linux-cr patches from www.linux-cr.org/pub/git/linux-cr.git
> > to the latest kernel (3.2-rc1). The tests (on x86_64) I have done so far
> > were successful. My repository with the C/R patches on top of 3.2-rc1 is
> > currently at:
> > 
> > http://lisas.de/~adrian/linux-cr.git
> > 
> > 
> > The development on the linux-cr tree hast stopped sometime around 2.6.37
> > and although those patches have gone through many revisions I am not sure
> > about the latest state of those patches concerning inclusion. At what
> > point has the discussion stopped and why?
> 
> AFAIK very few people from the community support the idea of having the C/R
> functionality implemented as the kernel subsystem.
> 
> > I have seen patches from Pavel about another approach for 
> > checkpointing/restarting but I haven't heard anything about
> > that during the last months.
> > 
> > What are the chances to get one of the checkpointing/restarting
> > implementations included. What is still missing from the one I used?
> 
> The chances are ... quite high. We implement our C/R code in the userspace
> and require very few pieces from kernel. So far 2 out of 3 proposed API
> extensions were merged into -mm tree.

Hi Pavel,

does '2 out of 3 proposed' mean '2 out of 3 needed for full c/r support'?
(That was the implication, and would be great)  If not, the how many more
api extensions would you foresee needed for that?

> > What is the latest state of Pavel's patches?
> 
> The state right now is - we can dump and restore tasks with any types of
> memory, open regular files and pipes with its contents. The code is currently 
> under internal review process. We're going to send the public RFC early next 
> week. Then go on with more resources to dump and restore.
> 
> > 		Adrian
> > .
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
