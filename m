Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab1JMFsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 01:48:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab1JMFsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 01:48:12 -0400
Date: Thu, 13 Oct 2011 07:48:09 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Rientjes <rientjes@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <htejun@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] lguest: move process freezing before pending signals
 check
Message-ID: <20111013054809.GB467@tiehlicka.suse.cz>
References: <cover.1317110948.git.mhocko@suse.cz>
 <e213ea00900cba783f228eb4234ad929a05d4359.1317110948.git.mhocko@suse.cz>
 <20111012065504.GC31570@tiehlicka.suse.cz>
 <87lispepbg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lispepbg.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-10-11 10:27:07, Rusty Russell wrote:
> On Wed, 12 Oct 2011 08:55:04 +0200, Michal Hocko <mhocko@suse.cz> wrote:
> > Hi Rusty,
> > what is the current state of this patch? Are you planning to push it for
> > 3.2?
> 
> Oh.  Having acked it, I assumed you'd push.  But I've put it in my queue
> now.

Thanks

> 
> Thanks,
> Rusty.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
