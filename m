Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab0KRKbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:31:22 -0500
Received: from relay01.mx.bawue.net ([193.7.176.67]:37748 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab0KRKbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:31:21 -0500
Date: Thu, 18 Nov 2010 11:31:17 +0100
From: Nils Radtke <lkml@Think-Future.com>
To: Dan Carpenter <error27@gmail.com>, gregkh@suse.de,
        kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wlan-ng: p80211netdev.c cleanup
Message-ID: <20101118103117.GO8821@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.com>
Mail-Followup-To: Nils Radtke <lkml@Think-Future.com>,
	Dan Carpenter <error27@gmail.com>, gregkh@suse.de,
	kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1284834652-26171-1-git-send-email-lkml@Think-Future.com>
 <20100918204112.GA6236@bicker>
 <20101117145548.GA6794@localhost>
 <20101117213246.GJ31724@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117213246.GJ31724@bicker>
X-Url: http://www.Think-Future.de
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Dan,

  Thank you for your reply.

# I don't want to be rude, but it's basically a kernel hacker rule that
# after you introduce a bug (and your last cleanup patch did) that you
# have to fix a bug to make up for it.  One excellent source of easy bugs
No offense taken. There are already other mails in 
the pipe to actually do that last "multi"-patch properly. Just felt
to finally give feedback at least.

# is using static checkers.
I just used smatch as you proposed. That's where I started to dive into
some code that I had to understand before continuing "fixing" something else.
And I still try to figure out some pieces (had a big break for the locality 
change too).. More in the upcoming mails. 

# I've found a static checker bug for you.
You've been invaluable already, thank you. I'll try myself one after another. 
Maybe first the bug found by smatch (some offset prob), then this one. Hm, we'll see.

Some answer right away, the rest gets pushed on the todo stack.

# 4)  Is it a special case where the caller handles it differently?
# 	Use cscope for this.
# 	^] takes you back a step.
Good hint, thx. Hitting esc+alt+] is so "expensive" with this kb layout (you risk 
breaking your hand doing that).. ;)

# 	cscope is an essential kernel hacking tool.
Thank you very much for your detailed explanation. I am already familiar 
with cscope, in this case.

# !skb is better as Al Viro explains in this email:
# http://lwn.net/Articles/331593/
Great, thank you!

      Cheers,


            Nils


-- 
:x            Think-Future.com                                    :)
   Yevtushenko has... an ego that can crack crystal at a distance of
   twenty feet.   -- John Cheever 
   
