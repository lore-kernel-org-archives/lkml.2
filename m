Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0ENQlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:41:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:26307 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab0ENQlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LFpKDjolihfnWb/pWFtTEoBnPiGMEA/SVesuuIXiWlFnsg1BDvrihSEB5SqqZ8GdCN
         L4a69THjwodn3dsd/3zB895pt5gxZif1iuRo9DRuqvGV37hyyZgmsfCBqivMANzy/JBg
         HF/vW31/Yp7bUK21wEHsvc3yHh3pNHVfawZDY=
Date: Fri, 14 May 2010 20:40:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Performance Events hangs with Intel P4 system
Message-ID: <20100514164057.GC13509@lenovo>
References: <AANLkTimrHGq1kZwPev7gBZu6Hqxlhe0ZscSKjEinZtcf@mail.gmail.com> <AANLkTik-gIjZu60pFWEhhe8MolQITrtk0wfpvSUCLnrD@mail.gmail.com> <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com> <1273834571.3530.82.camel@minggr.sh.intel.com> <20100514115655.GA18069@elte.hu> <20100514135240.GA4952@lenovo> <20100514145213.GA13509@lenovo> <AANLkTik6rwpU665xKUWfaOhV-h3Xgm_xeSiXH0Ax-n2u@mail.gmail.com> <20100514162813.GB13509@lenovo> <AANLkTinSAEATJbnj5MwhuKlBtXEGzpdeoktkzktrESvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinSAEATJbnj5MwhuKlBtXEGzpdeoktkzktrESvw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 10:06:44PM +0530, Jaswinder Singh Rajput wrote:
...
> >
> > Thanks Jaswinder,
> >
> > it means counters management somehow screwed at moment (it was working before).
> > I'm working on it.
> >
> 
> Ok, I added few more events and now I am able see few hardware events :
> 
...
Thanks, but I need to figure out where they hide in first place. Will keep
you in touch.

	-- Cyrill
