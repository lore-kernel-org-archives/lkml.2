Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab2IQVie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 17:38:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62727 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2IQVid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 17:38:33 -0400
Date: Mon, 17 Sep 2012 14:38:29 -0700
From: Tejun Heo <tj@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, apm: Make on_cpu0() use workqueue instead of
 work_on_cpu()
Message-ID: <20120917213829.GN18677@google.com>
References: <20120824011134.GB21325@google.com>
 <alpine.LNX.2.00.1208281557000.22447@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1208281557000.22447@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 03:57:27PM -0700, Jiri Kosina wrote:
> On Thu, 23 Aug 2012, Tejun Heo wrote:
> 
> > Make APM schedule a work item on CPU0 instead of using the expensive
> > work_on_cpu(); hopefully, this is the last user of work_on_cpu() and
> > we can take out work_on_cpu() in not too distant future.
> > 
> > Tested both paths.  Seems to work fine.
> 
> Applying to apm.git, thanks Tejun.

It seems we need work_on_cpu() after all and I'm planning on
reimplementing it in saner way.  Can you please drop this one?

Thanks.

-- 
tejun
