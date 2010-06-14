Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab0FNXHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 19:07:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764Ab0FNXHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:07:36 -0400
Date: Mon, 14 Jun 2010 16:06:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, johannes@sipsolutions.net,
       oleg@redhat.com, axboe@kernel.dk
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#5
Message-Id: <20100614160610.3992e6cb.akpm@linux-foundation.org>
In-Reply-To: <4C16B085.3030707@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	<20100614145839.8ac7687a.akpm@linux-foundation.org>
	<4C16AA75.8030303@kernel.org>
	<20100614153545.51fe0338.akpm@linux-foundation.org>
	<4C16B085.3030707@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 00:43:17 +0200
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 06/15/2010 12:35 AM, Andrew Morton wrote:
> > Nobody's going to remember all that stuff except yourself, and the info
> > might be out of date.  So please update and maintain that information
> > and retain it with the patchset.
> > 
> > eg: "<NEED SOME BACKING NUMBERS>".  And "Please read the patch
> > description of the last patch for more details" is out of date.
> > 
> > Because right now I have a bunch of code in my inbox and little
> > (actually "no") idea why anyone might want to merge it into anything.
> >
> > Trying to review a large patchset when you don't have an overall
> > picture of what it's trying to do and how it's trying to do it is
> > rather painful - you have to work all that stuff out from the
> > implementation.  It's also error-prone if the implementation doesn't
> > implement that which the author thinks it implements (ie: if it has
> > design bugs).
> 
> Well, basics of the whole thing didn't change all that much since the
> first take and most people on cc list were cc'd on each take.  The
> biggest reason I'm still carrying the whole patchset is due to the
> scheduler changes.  The numbers are in the third take (which you can
> follow the links to find out).  Anyways, I'll write up another summary
> tomorrow.
> 

Thanks.  I don't think I've looked at these patches at all since the
first version, and I'd like to.  That was many many thousands of
patches ago and I don't remember anything useful at all about them.  
