Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab0EPLul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 07:50:41 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37098 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751409Ab0EPLuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 07:50:40 -0400
Date: Fri, 7 May 2010 15:43:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nico Schottelius <nico-kernel@schottelius.org>,
       Nico Schottelius <nico-linux-20100427@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: 2.6.33-2.6.34-rc5 suspend issues
Message-ID: <20100507134302.GB3089@ucw.cz>
References: <20100427074609.GA3261@ikn.schottelius.org>
 <20100427083202.GA3143@ikn.schottelius.org>
 <20100428160935.GA4010@schottelius.org>
 <20100429191241.GA3407@schottelius.org>
 <20100501122441.GA3273@schottelius.org>
 <20100504041849.GA1262@ucw.cz>
 <20100504144714.GA3527@schottelius.org>
 <20100507135704.GB3455@schottelius.org>
 <20100512060843.GA20895@schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512060843.GA20895@schottelius.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > > Same happens on 2.6.34-rc5-00340-g79dba2e, now testing
> > > > > 2.6.34-rc6-00063-gbe1066b.
> > > > 
> > > > There's one bit that needs to be set to stay in the acpi mode, and
> > > > there's blacklist somewhere...?
> > > 
> > > Don't know if I should answer the question, but the problem also happens
> > > on 2.6.34-rc6-00063-gbe1066b.
> > > 
> > > Now compiling v2.6.34-rc6-106-gd93ac51.
> > 
> > Same issue on 2.6.34-rc6-00201-g722154e.
> 
> Success, success! With 2.6.34-rc7 I can resume at least two times!
> 
> I'll keep an eye on it and notify you if things continue to work / break again.
> 

Congratulations. I have no idea what fixed it, but hopefully it will
keep working.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
