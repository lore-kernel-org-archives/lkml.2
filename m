Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab1DUEYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 00:24:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41769 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1DUEYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 00:24:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [Stable-review] [48/70] vmscan: all_unreclaimable() use zone->all_unreclaimable as a name
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, Nick Piggin <npiggin@kernel.dk>,
        David Rientjes <rientjes@google.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
In-Reply-To: <1303357246.3464.136.camel@localhost>
References: <20110419201048.281575300@clark.kroah.org> <1303357246.3464.136.camel@localhost>
Message-Id: <20110421132442.7327.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 21 Apr 2011 13:24:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2011-04-19 at 13:08 -0700, Greg KH wrote:
> > 2.6.38-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > 
> > commit 929bea7c714220fc76ce3f75bef9056477c28e74 upstream.
> > 
> > all_unreclaimable check in direct reclaim has been introduced at 2.6.19
> > by following commit.
> > 
> > 	2006 Sep 25; commit 408d8544; oom: use unreclaimable info
> > 
> > And it went through strange history. firstly, following commit broke
> > the logic unintentionally.
> > 
> > 	2008 Apr 29; commit a41f24ea; page allocator: smarter retry of
> > 				      costly-order allocations
> [...]
> 
> So presumably this needs to be fixed in 2.6.32.y and other longterm
> series as well.  Though there seems to be a whole series of fixes
> required in 2.6.32.y!
> 
> Are you going to look after that, or should someone else prepare
> backports?  (I'm certainly not volunteering - I don't have the VM
> knowledge to work out what needs doing.)

Hi Ben

Honestly, I didn't prepare. If my remember is correct, you are debian 
guy. So, Can I think the backport 2.6.32.y help debian people? If so,
it's good thing to increase my priority to do this.

Thanks.



