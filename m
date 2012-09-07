Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab2IGNMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:12:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab2IGNMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:12:01 -0400
Date: Fri, 7 Sep 2012 15:11:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Emil Goode <emilgoode@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] HID: picoLCD: Remove use of deprecated function
In-Reply-To: <20120906201538.GK29092@google.com>
Message-ID: <alpine.LNX.2.00.1209071511060.21679@pobox.suse.cz>
References: <1346942780-8091-1-git-send-email-emilgoode@gmail.com> <20120906221252.1402ba50@neptune.home> <20120906201538.GK29092@google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Sep 2012, Tejun Heo wrote:

> > > The flush_delayed_work_sync function is deprecated,
> > > we can instead call flush_delayed_work directly.
> > > 
> > > Sparse is giving a warning:
> > > drivers/hid/hid-picolcd_fb.c:611:2: warning:
> > > 	‘flush_delayed_work_sync’ is deprecated
> > > 	(declared at include/linux/workqueue.h:454)
> > > 	[-Wdeprecated-declarations]
> > > 
> > > Signed-off-by: Emil Goode <emilgoode@gmail.com>
> > 
> > Acked-by: Bruno Prémont <bonbons@linux-vserver.org>
> > 
> > This matches a patch by Tejun a few weeks ago which was partially
> > skipped in -next due to merge conflict with code split in picoLCD.
> > 
> > See http://comments.gmane.org/gmane.linux.kernel.next/23740
> > 
> > For the sake of proper bisectability, this should go in after
> > Tejun's workqueue changes (if needed at all depending on how merge
> > happens during pull by Linus).
> 
> Yeah, we either can ask Linus to fix it up during merge or send a
> separate patch afterwards.  In this case, I don't think it matters too
> much either way.  I tend to send out pull request fairly early in the
> merge window, I'll try to remember to poke Linus about the merge
> conflict.

Okay, fair enough. I'll try not to forget to CC you on my pull request 
which will include those picolcd changes, and mention the potential 
conflict to Linus as well. We'll see which one goes in first :)

Thanks,

-- 
Jiri Kosina
SUSE Labs
