Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab0FOMxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 08:53:18 -0400
Received: from THUNK.ORG ([69.25.196.29]:59409 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0FOMxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 08:53:16 -0400
Date: Tue, 15 Jun 2010 08:53:02 -0400
From: tytso@mit.edu
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#5
Message-ID: <20100615125302.GK6666@thunk.org>
Mail-Followup-To: tytso@mit.edu, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
	awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
	rusty@rustcorp.com.au, cl@linux-foundation.org, dhowells@redhat.com,
	arjan@linux.intel.com, johannes@sipsolutions.net, oleg@redhat.com,
	axboe@kernel.dk
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
 <20100614145839.8ac7687a.akpm@linux-foundation.org>
 <4C16AA75.8030303@kernel.org>
 <20100614153545.51fe0338.akpm@linux-foundation.org>
 <4C16B085.3030707@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C16B085.3030707@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 12:43:17AM +0200, Tejun Heo wrote:
> 
> Well, basics of the whole thing didn't change all that much since the
> first take and most people on cc list were cc'd on each take.  The
> biggest reason I'm still carrying the whole patchset is due to the
> scheduler changes.  The numbers are in the third take (which you can
> follow the links to find out).  Anyways, I'll write up another summary
> tomorrow.

It really helps if patch summaries are self contained and don't
require a bunch of kernel developers who are trying to review things
to have to do research and then figure out which links are the right
ones to chase down.  It's also not reasonable to expect your reviewers
to diff your patches to determine how much has changed and whether
they should expect benchmarks run from months ago to still be
applicable or not.

Many of us get literally hundreds of e-mail messages a day, and
e-mails are read with one finger hovering over the the 'd' key.  It
simply scales better if you don't assume that everybody else considers
the patch as important as you do, and instead assume that most people
have forgotten patches sent months ago....  

Regards,

						- Ted
