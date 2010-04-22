Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0DVXEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 19:04:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753676Ab0DVXEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 19:04:33 -0400
Date: Thu, 22 Apr 2010 16:04:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: John Villalovos <sodarock@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
       oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, stable@kernel.org
Subject: Re: [PATCH] oprofile: remove double ring buffering
Message-Id: <20100422160411.cfcae4e1.akpm@linux-foundation.org>
In-Reply-To: <m2h5e61b72f1004220733n65451418p7c321f07eb5d6b58@mail.gmail.com>
References: <20100401011725.GA27567@basil.fritz.box>
	<20100401190205.GD6027@erda.amd.com>
	<m2h5e61b72f1004220733n65451418p7c321f07eb5d6b58@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010 10:33:56 -0400
John Villalovos <sodarock@gmail.com> wrote:

> On Thu, Apr 1, 2010 at 3:02 PM, Robert Richter <robert.richter@amd.com> wrote:
> > On 01.04.10 03:17:25, Andi Kleen wrote:
> >> Got confirmation now this patch fixes most of the dropped oprofile
> >> samples problem on a particular intensive test on a large system.
> >> So now submitting the previous RFC formally.
> >> .34 / Stable candidate.
> >
> > Thanks Andi, will take a look at this next week.
> 
> I was wondering what the state of this patch is.  I don't see it in
> linux-2.6 or linux-next. or in
> git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git
> 

I queued it in my for-2.6.34-via-subsystem-maintainer pile.  I'll start
sending those things out for everyone to ignore early next week I guess.

