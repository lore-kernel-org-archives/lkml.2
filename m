Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0DIXcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 19:32:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:54488 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755089Ab0DIXck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 19:32:40 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX188CasAbSw8YexCg3zPokzF9dOxH9aSkkF4rltiTj
	dKePmFKajQ1Nuv
Message-ID: <4BBFB914.1020600@gmx.de>
Date: Sat, 10 Apr 2010 01:32:36 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [RFC] Initial OLPC Viafb merge
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>	<4BBEBE87.4000809@gmx.de> <20100409124626.0b150104@bike.lwn.net>
In-Reply-To: <20100409124626.0b150104@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet schrieb:
> Sorry, the only working platform I had was the OLPC 2.6.31 tree, and
> there was little point in publishing that by the time it was ready to
> be seen.  That said, I *did* point out the tree where the work could be
> seen for anybody who was interested.

Well the time I looked in your tree I didn't see any of the remaining 
suspend/resume efforts. Okay perhaps I should have rechecked it now and 
than.
Please correct me if I am wrong but the remaining 6 patches concerning 
suspend&resume look like a real big FIXME. So at the end it is expected 
to work only on VX855 and needs something called OFW?
It doesn't seem to make much sense to review each of them because the 
following patches might or might not correct some of the issues of the 
other. It is really a pain to have 6 patches trying to add a single 
feature. Is there any way to fix this mess. (I assume you didn't merge 
them due to authorship issues?)
I think it might be better to drop those for now and wait for viafb to 
be in a better shape before adding this feature. The mode setting should 
be in a pretty good shape just 1 or 2 kernel versions ahead so that the 
dependency on OFW can be dropped I think.

Sorry but I really think this is not in a shape where merging it is an 
option. I think it would be better to skip those suspend/resume patches 
for the next merge window.


Thanks,

Florian Tobias Schandinat
