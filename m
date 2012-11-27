Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2K0VZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 16:25:17 -0500
Received: from science.horizon.com ([71.41.210.146]:64073 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751764Ab2K0VZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 16:25:15 -0500
Date: 27 Nov 2012 16:25:14 -0500
Message-ID: <20121127212514.1173.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, mgorman@suse.de
Subject: Re: 3.7-rc6 soft lockup in kswapd0
Cc: dave@linux.vnet.ibm.com, hannes@cmpxchg.org, jack@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@redhat.com
In-Reply-To: <20121126190926.GM8218@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> wrote:
> On Mon, Nov 26, 2012 at 01:53:17PM -0500, George Spelvin wrote:
>> Johannes Weiner <hannes@cmpxchg.org> wrote:
>>> Any chance you could test with this fix instead, in addition to Dave's
>>> accounting fix?  It's got bool and everything!
> 
>> Okay.  Mel, speak up if you object.  I also rebased on top of 3.7-rc7,
>> which already includes Dave's fix.  Again, speak up if that's a bad idea.
> 
> No objections all round.

Well, it just made it to 24 hours, 
it did before.  I'm going to wait a couple more days before declaring
victory, but it looks good so far.

 19:19:10 up 1 day, 0 min,  2 users,  load average: 0.15, 0.20, 0.22
 21:24:05 up 1 day,  2:05,  2 users,  load average: 0.25, 0.19, 0.18
