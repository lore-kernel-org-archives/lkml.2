Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab0FNWgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:36:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757143Ab0FNWgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:36:47 -0400
Date: Mon, 14 Jun 2010 15:35:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, johannes@sipsolutions.net,
       oleg@redhat.com, axboe@kernel.dk
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#5
Message-Id: <20100614153545.51fe0338.akpm@linux-foundation.org>
In-Reply-To: <4C16AA75.8030303@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	<20100614145839.8ac7687a.akpm@linux-foundation.org>
	<4C16AA75.8030303@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 00:17:25 +0200
Tejun Heo <tj@kernel.org> wrote:

> On 06/14/2010 11:58 PM, Andrew Morton wrote:
> > On Mon, 14 Jun 2010 23:37:17 +0200
> > Tejun Heo <tj@kernel.org> wrote:
> > 
> >> This is the fifth take of cmwq (concurrency managed workqueue)
> >> patchset.
> > 
> > What is a concurrency managed workqueue and why do we want one?
> 
> That goes back about 9 month.  You were cc'd there too.  :-)
> 
>   http://thread.gmane.org/gmane.linux.kernel/896268
> 

Nobody's going to remember all that stuff except yourself, and the info
might be out of date.  So please update and maintain that information
and retain it with the patchset.

eg: "<NEED SOME BACKING NUMBERS>".  And "Please read the patch
description of the last patch for more details" is out of date.

Because right now I have a bunch of code in my inbox and little
(actually "no") idea why anyone might want to merge it into anything.

Trying to review a large patchset when you don't have an overall
picture of what it's trying to do and how it's trying to do it is
rather painful - you have to work all that stuff out from the
implementation.  It's also error-prone if the implementation doesn't
implement that which the author thinks it implements (ie: if it has
design bugs).

