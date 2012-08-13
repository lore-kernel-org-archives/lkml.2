Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2HMQW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:22:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53365 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2HMQW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:22:56 -0400
Date: Mon, 13 Aug 2012 13:22:46 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 5/6] floppy: remove check for allocated queue on
 do_floppy_init error handling
Message-ID: <20120813162242.GB23193@herton-Z68MA-D2H-B3>
References: <1344542391-16474-1-git-send-email-herton.krzesinski@canonical.com>
 <1344542391-16474-6-git-send-email-herton.krzesinski@canonical.com>
 <20120810173653.GK5416@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120810173653.GK5416@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 01:36:53PM -0400, Vivek Goyal wrote:
> On Thu, Aug 09, 2012 at 04:59:50PM -0300, Herton Ronaldo Krzesinski wrote:
> > The check "if (disks[dr]->queue)" check is bogus, if we reach there
> > for each dr should exist an queue allocated (note that we decrement dr
> > first on entering the loop).
> > 
> > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> 
> As mentioned in second patch, I like going trhough full array of drives
> and do cleanup as needed instead of relying on "dr" variable. 
> 
> But if you don't like that, then I am not as such against this approach.
> Was just trying to keep all put_disk() at one place.

Ok, I'll drop this, and do a full cleanup. I just ended up doing the
minimal work, but I'm not against cleaning this. I still want to keep
the second patch, as being a simple/appropriate bug fix for stable. I'll
submit a new series soon. Thanks for looking at this series.

> 
> Thanks
> Vivek
> 

-- 
[]'s
Herton
